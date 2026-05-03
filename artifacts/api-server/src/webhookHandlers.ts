import { getStripeSync } from './stripeClient';
import { billingStorage } from './billingStorage';

export class WebhookHandlers {
  static async processWebhook(payload: Buffer, signature: string): Promise<void> {
    if (!Buffer.isBuffer(payload)) {
      throw new Error(
        'STRIPE WEBHOOK ERROR: Payload must be a Buffer. ' +
        'This usually means express.json() parsed the body before reaching this handler. ' +
        'FIX: Ensure webhook route is registered BEFORE app.use(express.json()).'
      );
    }

    const sync = await getStripeSync();
    await sync.processWebhook(payload, signature);

    // After syncing, update application billing table
    try {
      const stripe = sync as any;
      const event = stripe._lastEvent;
      if (event) {
        await WebhookHandlers.handleBusinessLogic(event);
      }
    } catch {
      // Non-critical: billing table update is best-effort
    }
  }

  static async handleBusinessLogic(event: any): Promise<void> {
    const type = event.type;

    if (type === 'customer.subscription.created' || type === 'customer.subscription.updated') {
      const sub = event.data.object;
      const customerId = sub.customer;
      const status = sub.status; // 'active', 'past_due', 'canceled', etc.
      await billingStorage.updateSubscriptionStatus(customerId, sub.id, status);
    }

    if (type === 'customer.subscription.deleted') {
      const sub = event.data.object;
      await billingStorage.updateSubscriptionStatus(sub.customer, sub.id, 'canceled');
    }

    if (type === 'checkout.session.completed') {
      const session = event.data.object;
      if (session.customer && session.customer_details?.email) {
        await billingStorage.ensureCustomerRecord(
          session.customer,
          session.customer_details.email,
          session.metadata?.supabase_uid || null
        );
      }
    }
  }
}
