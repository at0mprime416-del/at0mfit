/**
 * AT0M FIT — Stripe Product Seed Script
 *
 * Creates products and prices in Stripe for:
 *   1. AT0M FIT Blueprint — one-time purchase ($27)
 *   2. AT0M FIT Coaching  — monthly subscription (set your price below)
 *
 * Run with: pnpm --filter @workspace/scripts run seed-products
 *
 * Safe to run multiple times (idempotent — checks by name before creating).
 * Requires: STRIPE_SECRET_KEY in environment secrets.
 */

import Stripe from 'stripe';

function getStripeKey(): string {
  const key = process.env.STRIPE_SECRET_KEY;
  if (!key) {
    throw new Error(
      'STRIPE_SECRET_KEY is not set. Add it in the Replit Secrets tab.'
    );
  }
  return key;
}

async function seedProducts() {
  const stripe = new Stripe(getStripeKey());

  console.log('Seeding AT0M FIT products in Stripe...\n');

  // ── BLUEPRINT (one-time) ───────────────────────────────────────────────────
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
      description:
        'The complete Zone 2 to Zone 4 training system. Aerobic base, threshold work, and sprint programming for the serious athlete.',
      metadata: { product_type: 'blueprint' },
    });
    console.log(`Created Blueprint product: ${blueprintProduct.id}`);
  }

  const blueprintPrices = await stripe.prices.list({
    product: blueprintProduct.id,
    active: true,
  });
  if (blueprintPrices.data.length === 0) {
    const price = await stripe.prices.create({
      product: blueprintProduct.id,
      unit_amount: 2700,
      currency: 'usd',
    });
    console.log(`Created Blueprint price: $27.00 one-time (${price.id})`);
  } else {
    console.log(`Blueprint price already exists: ${blueprintPrices.data[0].id}`);
  }

  console.log('');

  // ── COACHING SUBSCRIPTION (recurring) ─────────────────────────────────────
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
      description:
        'Custom online training coaching. Personalized programming, weekly check-ins, nutrition guidance, and direct coach access.',
      metadata: { product_type: 'training' },
    });
    console.log(`Created Coaching product: ${coachingProduct.id}`);
  }

  const coachingPrices = await stripe.prices.list({
    product: coachingProduct.id,
    active: true,
  });
  if (coachingPrices.data.length === 0) {
    // ── SET YOUR COACHING MONTHLY PRICE HERE ──────────────────────────────
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

  console.log('\nDone. Restart the API server workflow to pick up the new products.');
}

seedProducts().catch((err) => {
  console.error('Seed failed:', err.message);
  process.exit(1);
});
