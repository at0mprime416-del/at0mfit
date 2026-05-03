import { Router } from 'express';
import { getUncachableStripeClient } from '../stripeClient';
import { billingStorage } from '../billingStorage';
import { logger } from '../lib/logger';

const router = Router();

const BASE_URL = process.env.REPLIT_DOMAINS
  ? `https://${process.env.REPLIT_DOMAINS.split(',')[0]}`
  : 'http://localhost:3000';

// Verify Supabase JWT and extract user info
// Uses the anon key to verify the token via Supabase REST API
async function verifySupabaseToken(authHeader: string | undefined): Promise<{ id: string; email: string } | null> {
  if (!authHeader?.startsWith('Bearer ')) return null;
  const token = authHeader.slice(7);
  const supabaseUrl = process.env.VITE_SUPABASE_URL;
  const supabaseKey = process.env.VITE_SUPABASE_ANON_KEY;
  if (!supabaseUrl || !supabaseKey) return null;
  try {
    const res = await fetch(`${supabaseUrl}/auth/v1/user`, {
      headers: { Authorization: `Bearer ${token}`, apikey: supabaseKey }
    });
    if (!res.ok) return null;
    const data = await res.json();
    return data?.id ? { id: data.id, email: data.email } : null;
  } catch {
    return null;
  }
}

// GET /api/stripe/products-with-prices
router.get('/stripe/products-with-prices', async (_req, res) => {
  try {
    const stripe = await getUncachableStripeClient();
    const products = await stripe.products.list({ active: true, limit: 20 });
    const result = await Promise.all(
      products.data.map(async (p) => {
        const prices = await stripe.prices.list({ product: p.id, active: true });
        return { ...p, prices: prices.data };
      })
    );
    res.json({ data: result });
  } catch (err: any) {
    logger.error({ err }, 'Failed to fetch Stripe products');
    res.status(500).json({ error: 'Failed to fetch products' });
  }
});

// POST /api/stripe/checkout — requires Supabase auth for subscriptions
router.post('/stripe/checkout', async (req, res) => {
  try {
    const { product_type, price_id } = req.body;
    const user = await verifySupabaseToken(req.headers.authorization);
    const stripe = await getUncachableStripeClient();

    let customerId: string | undefined;

    if (user) {
      const existing = await billingStorage.getBySupabaseUid(user.id)
        || await billingStorage.getByEmail(user.email);
      if (existing?.stripe_customer_id) {
        customerId = existing.stripe_customer_id;
      } else {
        const customer = await stripe.customers.create({
          email: user.email,
          metadata: { supabase_uid: user.id, product_type: product_type || 'training' }
        });
        await billingStorage.upsert({
          supabase_uid: user.id,
          email: user.email,
          stripe_customer_id: customer.id,
          product_type: product_type || 'training'
        });
        customerId = customer.id;
      }
    }

    const isSubscription = product_type === 'training' || product_type === 'subscription';
    const mode = isSubscription ? 'subscription' : 'payment';

    const sessionParams: any = {
      payment_method_types: ['card'],
      mode,
      success_url: `${BASE_URL}/checkout/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${BASE_URL}/checkout/cancel`,
      metadata: {
        product_type: product_type || 'blueprint',
        supabase_uid: user?.id || '',
      },
    };

    if (customerId) sessionParams.customer = customerId;
    if (user?.email && !customerId) sessionParams.customer_email = user.email;

    if (price_id) {
      sessionParams.line_items = [{ price: price_id, quantity: 1 }];
    } else {
      // Fallback: look up by product metadata
      const products = await stripe.products.search({
        query: `active:'true' AND metadata['product_type']:'${product_type}'`
      });
      const product = products.data[0];
      if (!product) {
        return res.status(404).json({ error: `No active product found for type: ${product_type}. Run seed-products.ts first.` });
      }
      const prices = await stripe.prices.list({ product: product.id, active: true });
      const price = prices.data[0];
      if (!price) {
        return res.status(404).json({ error: 'No active price found for product.' });
      }
      sessionParams.line_items = [{ price: price.id, quantity: 1 }];
    }

    const session = await stripe.checkout.sessions.create(sessionParams);
    res.json({ url: session.url });
  } catch (err: any) {
    logger.error({ err }, 'Checkout session error');
    res.status(500).json({ error: err.message || 'Failed to create checkout session' });
  }
});

// POST /api/stripe/customer-portal — requires Supabase auth
router.post('/stripe/customer-portal', async (req, res) => {
  try {
    const user = await verifySupabaseToken(req.headers.authorization);
    if (!user) return res.status(401).json({ error: 'Authentication required' });

    const billing = await billingStorage.getBySupabaseUid(user.id)
      || await billingStorage.getByEmail(user.email);
    if (!billing?.stripe_customer_id) {
      return res.status(404).json({ error: 'No billing record found. Complete a purchase first.' });
    }

    const stripe = await getUncachableStripeClient();
    const session = await stripe.billingPortal.sessions.create({
      customer: billing.stripe_customer_id,
      return_url: `${BASE_URL}/portal`,
    });
    res.json({ url: session.url });
  } catch (err: any) {
    logger.error({ err }, 'Customer portal error');
    res.status(500).json({ error: err.message || 'Failed to create billing portal session' });
  }
});

// GET /api/stripe/billing-status — requires Supabase auth
router.get('/stripe/billing-status', async (req, res) => {
  try {
    const user = await verifySupabaseToken(req.headers.authorization);
    if (!user) return res.json({ status: 'unauthenticated', subscription_status: null });

    const billing = await billingStorage.getBySupabaseUid(user.id)
      || await billingStorage.getByEmail(user.email);

    if (!billing) return res.json({ status: 'none', subscription_status: null });

    res.json({
      status: 'found',
      subscription_status: billing.subscription_status,
      product_type: billing.product_type,
      stripe_customer_id: billing.stripe_customer_id,
    });
  } catch (err: any) {
    logger.error({ err }, 'Billing status error');
    res.status(500).json({ error: 'Failed to fetch billing status' });
  }
});

// GET /api/stripe/verify-session — verify a completed checkout session
router.get('/stripe/verify-session', async (req, res) => {
  try {
    const { session_id } = req.query as { session_id?: string };
    if (!session_id) return res.status(400).json({ error: 'session_id is required' });

    const stripe = await getUncachableStripeClient();
    const session = await stripe.checkout.sessions.retrieve(session_id);

    if (session.payment_status === 'paid' || session.status === 'complete') {
      res.json({
        status: 'complete',
        product_type: session.metadata?.product_type || null,
        customer_email: session.customer_details?.email || null,
      });
    } else {
      res.json({ status: session.status, product_type: null });
    }
  } catch (err: any) {
    logger.error({ err }, 'Verify session error');
    res.status(500).json({ error: 'Failed to verify session' });
  }
});

export default router;
