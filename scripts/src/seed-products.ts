/**
 * AT0M FIT — Stripe Product Seed Script
 * 
 * Creates products and prices in Stripe for:
 *   1. AT0M FIT Blueprint — one-time purchase ($27)
 *   2. AT0M FIT Coaching — monthly subscription ($X — set your price)
 * 
 * Run with: pnpm --filter @workspace/scripts exec tsx src/seed-products.ts
 * 
 * Safe to run multiple times (idempotent check by name).
 */

import Stripe from 'stripe';

async function getStripeCredentials(): Promise<string> {
  const hostname = process.env.REPLIT_CONNECTORS_HOSTNAME;
  const xReplitToken = process.env.REPL_IDENTITY
    ? "repl " + process.env.REPL_IDENTITY
    : process.env.WEB_REPL_RENEWAL
      ? "depl " + process.env.WEB_REPL_RENEWAL
      : null;

  if (!hostname || !xReplitToken) {
    throw new Error('Missing Replit env vars. Run this script inside the Replit environment.');
  }

  const resp = await fetch(
    `https://${hostname}/api/v2/connection?include_secrets=true&connector_names=stripe`,
    {
      headers: { Accept: 'application/json', X_REPLIT_TOKEN: xReplitToken },
      signal: AbortSignal.timeout(10_000),
    }
  );

  if (!resp.ok) throw new Error(`Failed to fetch Stripe credentials: ${resp.status}`);
  const data = await resp.json();
  const key = data.items?.[0]?.settings?.secret_key;
  if (!key) throw new Error('Stripe integration not connected.');
  return key;
}

async function seedProducts() {
  const secretKey = await getStripeCredentials();
  const stripe = new Stripe(secretKey);

  console.log('Seeding AT0M FIT products...\n');

  // ── BLUEPRINT (one-time) ────────────────────────────────────────────────────
  const existingBlueprint = await stripe.products.search({
    query: "name:'AT0M FIT Blueprint' AND active:'true'"
  });

  let blueprintProduct: Stripe.Product;
  if (existingBlueprint.data.length > 0) {
    blueprintProduct = existingBlueprint.data[0];
    console.log(`Blueprint already exists: ${blueprintProduct.id}`);
  } else {
    blueprintProduct = await stripe.products.create({
      name: 'AT0M FIT Blueprint',
      description: 'The complete Zone 2 to Zone 4 training system. Aerobic base, threshold work, and sprint programming for the serious athlete.',
      metadata: { product_type: 'blueprint' },
    });
    console.log(`Created Blueprint product: ${blueprintProduct.id}`);
  }

  const blueprintPrices = await stripe.prices.list({ product: blueprintProduct.id, active: true });
  if (blueprintPrices.data.length === 0) {
    const price = await stripe.prices.create({
      product: blueprintProduct.id,
      unit_amount: 2700, // $27.00
      currency: 'usd',
    });
    console.log(`Created Blueprint price: $27.00 one-time (${price.id})`);
  } else {
    console.log(`Blueprint price already exists: ${blueprintPrices.data[0].id}`);
  }

  console.log('');

  // ── COACHING SUBSCRIPTION (recurring) ──────────────────────────────────────
  const existingCoaching = await stripe.products.search({
    query: "name:'AT0M FIT Coaching' AND active:'true'"
  });

  let coachingProduct: Stripe.Product;
  if (existingCoaching.data.length > 0) {
    coachingProduct = existingCoaching.data[0];
    console.log(`Coaching already exists: ${coachingProduct.id}`);
  } else {
    coachingProduct = await stripe.products.create({
      name: 'AT0M FIT Coaching',
      description: 'Custom online training coaching. Personalized programming, weekly check-ins, nutrition guidance, and direct coach access.',
      metadata: { product_type: 'training' },
    });
    console.log(`Created Coaching product: ${coachingProduct.id}`);
  }

  const coachingPrices = await stripe.prices.list({ product: coachingProduct.id, active: true });
  if (coachingPrices.data.length === 0) {
    // SET YOUR COACHING PRICE BELOW
    const price = await stripe.prices.create({
      product: coachingProduct.id,
      unit_amount: 19900, // $199.00/month — change to your actual price
      currency: 'usd',
      recurring: { interval: 'month' },
    });
    console.log(`Created Coaching price: $199.00/month (${price.id})`);
  } else {
    console.log(`Coaching price already exists: ${coachingPrices.data[0].id}`);
  }

  console.log('\nDone. Run the API server to sync prices to the database.');
}

seedProducts().catch((err) => {
  console.error('Seed failed:', err.message);
  process.exit(1);
});
