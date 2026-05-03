import Stripe from 'stripe';
import { StripeSync } from 'stripe-replit-sync';

function getStripeCredentials(): { secretKey: string; webhookSecret: string } {
  const secretKey = process.env.STRIPE_SECRET_KEY;
  const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET ?? '';

  if (!secretKey) {
    throw new Error(
      'STRIPE_SECRET_KEY environment variable is not set. ' +
      'Add it in the Replit Secrets tab (sk_live_... or sk_test_...).'
    );
  }

  return { secretKey, webhookSecret };
}

export function getUncachableStripeClient(): Stripe {
  const { secretKey } = getStripeCredentials();
  return new Stripe(secretKey);
}

export function getStripeSync(): StripeSync {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    throw new Error('DATABASE_URL environment variable is required');
  }

  const { secretKey, webhookSecret } = getStripeCredentials();
  return new StripeSync({
    poolConfig: { connectionString: databaseUrl },
    stripeSecretKey: secretKey,
    stripeWebhookSecret: webhookSecret,
  });
}
