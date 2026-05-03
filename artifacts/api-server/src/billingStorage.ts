import pg from 'pg';

const { Pool } = pg;

let pool: pg.Pool | null = null;

function getPool(): pg.Pool {
  if (!pool) {
    const url = process.env.DATABASE_URL;
    if (!url) throw new Error('DATABASE_URL is required');
    pool = new Pool({ connectionString: url });
  }
  return pool;
}

export async function initBillingTable(): Promise<void> {
  const db = getPool();
  await db.query(`
    CREATE TABLE IF NOT EXISTS portal_billing (
      id SERIAL PRIMARY KEY,
      supabase_uid TEXT,
      email TEXT,
      stripe_customer_id TEXT UNIQUE NOT NULL,
      stripe_subscription_id TEXT,
      subscription_status TEXT DEFAULT 'none',
      product_type TEXT,
      updated_at TIMESTAMPTZ DEFAULT NOW()
    )
  `);
  await db.query(`
    CREATE INDEX IF NOT EXISTS idx_portal_billing_uid ON portal_billing (supabase_uid)
  `);
  await db.query(`
    CREATE INDEX IF NOT EXISTS idx_portal_billing_email ON portal_billing (email)
  `);
}

export const billingStorage = {
  async getBySupabaseUid(uid: string) {
    const db = getPool();
    const result = await db.query(
      'SELECT * FROM portal_billing WHERE supabase_uid = $1 LIMIT 1',
      [uid]
    );
    return result.rows[0] || null;
  },

  async getByEmail(email: string) {
    const db = getPool();
    const result = await db.query(
      'SELECT * FROM portal_billing WHERE email = $1 LIMIT 1',
      [email]
    );
    return result.rows[0] || null;
  },

  async getByCustomerId(customerId: string) {
    const db = getPool();
    const result = await db.query(
      'SELECT * FROM portal_billing WHERE stripe_customer_id = $1 LIMIT 1',
      [customerId]
    );
    return result.rows[0] || null;
  },

  async upsert(data: {
    supabase_uid?: string | null;
    email?: string | null;
    stripe_customer_id: string;
    stripe_subscription_id?: string | null;
    subscription_status?: string;
    product_type?: string;
  }) {
    const db = getPool();
    await db.query(`
      INSERT INTO portal_billing
        (supabase_uid, email, stripe_customer_id, stripe_subscription_id, subscription_status, product_type, updated_at)
      VALUES ($1, $2, $3, $4, $5, $6, NOW())
      ON CONFLICT (stripe_customer_id)
      DO UPDATE SET
        supabase_uid = COALESCE(EXCLUDED.supabase_uid, portal_billing.supabase_uid),
        email = COALESCE(EXCLUDED.email, portal_billing.email),
        stripe_subscription_id = COALESCE(EXCLUDED.stripe_subscription_id, portal_billing.stripe_subscription_id),
        subscription_status = COALESCE(EXCLUDED.subscription_status, portal_billing.subscription_status),
        product_type = COALESCE(EXCLUDED.product_type, portal_billing.product_type),
        updated_at = NOW()
    `, [
      data.supabase_uid || null,
      data.email || null,
      data.stripe_customer_id,
      data.stripe_subscription_id || null,
      data.subscription_status || 'none',
      data.product_type || null
    ]);
  },

  async updateSubscriptionStatus(customerId: string, subscriptionId: string, status: string) {
    const db = getPool();
    await db.query(`
      UPDATE portal_billing
      SET stripe_subscription_id = $2, subscription_status = $3, updated_at = NOW()
      WHERE stripe_customer_id = $1
    `, [customerId, subscriptionId, status]);
  },

  async ensureCustomerRecord(customerId: string, email: string, supabaseUid: string | null) {
    const existing = await this.getByCustomerId(customerId);
    if (!existing) {
      await this.upsert({ stripe_customer_id: customerId, email, supabase_uid: supabaseUid });
    } else if (supabaseUid && !existing.supabase_uid) {
      await this.upsert({ ...existing, supabase_uid: supabaseUid });
    }
  }
};
