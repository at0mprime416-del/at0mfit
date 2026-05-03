import app from "./app";
import { logger } from "./lib/logger";
import { runMigrations } from 'stripe-replit-sync';
import { getStripeSync } from "./stripeClient";
import { initBillingTable } from "./billingStorage";

async function initStripe() {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    logger.warn('DATABASE_URL not set — Stripe initialization skipped');
    return;
  }
  try {
    logger.info('Initializing Stripe schema...');
    await runMigrations({ databaseUrl, schema: 'stripe' });
    logger.info('Stripe schema ready');

    await initBillingTable();
    logger.info('Billing table ready');

    const stripeSync = await getStripeSync();
    const webhookBaseUrl = `https://${process.env.REPLIT_DOMAINS?.split(',')[0]}`;
    await stripeSync.findOrCreateManagedWebhook(`${webhookBaseUrl}/api/stripe/webhook`);
    logger.info('Stripe webhook configured');

    stripeSync.syncBackfill()
      .then(() => logger.info('Stripe data synced'))
      .catch((err) => logger.error({ err }, 'Stripe sync error'));
  } catch (err: any) {
    logger.error({ err }, 'Stripe initialization failed — continuing without Stripe');
  }
}

const rawPort = process.env["PORT"];

if (!rawPort) {
  throw new Error(
    "PORT environment variable is required but was not provided.",
  );
}

const port = Number(rawPort);

if (Number.isNaN(port) || port <= 0) {
  throw new Error(`Invalid PORT value: "${rawPort}"`);
}

await initStripe();

app.listen(port, (err) => {
  if (err) {
    logger.error({ err }, "Error listening on port");
    process.exit(1);
  }

  logger.info({ port }, "Server listening");
});
