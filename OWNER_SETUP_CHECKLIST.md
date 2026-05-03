# AT0M FIT — Owner Setup Checklist

**Status: PENDING OWNER ACTION**
These steps cannot be automated and require the owner to perform them manually.

---

## Step 1: Supabase SQL Setup

Run all three SQL files in order in the Supabase SQL editor:
Supabase Dashboard > SQL Editor > New Query

### Order:
1. `AT0M_FIT_FEATURE_EXPANSION.sql`
2. `FULL_PREMIUM_BUILDOUT_SETUP.sql`
3. `FINAL_HARDENING_SETUP.sql`

After each file runs, check for errors in the output. If any policy already exists, that is safe to ignore.

---

## Step 2: Supabase Storage Bucket

1. Go to: Supabase Dashboard > Storage
2. Click "New Bucket"
3. Name: `progress-photos`
4. Set to: PRIVATE (not public)
5. Click Create

Then add these RLS policies to the bucket (via SQL editor):

```sql
CREATE POLICY "Clients upload own photos" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'progress-photos' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Clients read own photos" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'progress-photos' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Coach reads all progress photos" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'progress-photos' AND
    auth.jwt() ->> 'email' = 'jeshua@levioperations.com'
  );
```

---

## Step 3: Replit Secrets

Go to: Replit > Tools > Secrets (lock icon in the sidebar)

Add the following secrets:

| Key | Value | Purpose |
|-----|-------|---------|
| `GMAIL_USER` | Your Gmail address | Sends coach notifications |
| `GMAIL_APP_PASSWORD` | Google App Password (not your Gmail login) | Gmail auth for notifications |
| `NOTIFICATION_TO_EMAIL` | Email to receive alerts | Where coach notifications are sent |
| `OPENAI_API_KEY` | Your OpenAI API key | Powers Ask AT0M AI responses |

**To get a Google App Password:**
1. Go to myaccount.google.com > Security
2. Enable 2-Step Verification if not already on
3. Search for "App Passwords" under Security
4. Create a new App Password for "Mail" / "Other"
5. Copy the 16-character password — use this as `GMAIL_APP_PASSWORD`

---

## Step 4: Restart API Server

After adding secrets:
1. Go to Replit > Workflows (top toolbar)
2. Find "API Server"
3. Click Restart

Verify by visiting: `{your-replit-url}/api/healthz` — should return `{"ok":true}`

---

## Step 5: Legal Pages Review

The following pages are live as DRAFT placeholders:
- `/terms` — Terms of Service
- `/privacy` — Privacy Policy
- `/waiver` — Training Waiver

**Required action:** Review each page with qualified legal counsel. Fill in:
- Your jurisdiction / governing law
- Payment and refund terms
- Contact email address
- Any jurisdiction-specific requirements (GDPR if EU users, CCPA if California users)

Remove the "Draft" banner from each page after legal approval.

---

## Step 6: Publish / Deploy

When all above steps are complete:
1. In Replit, click the Deploy button
2. Configure your domain (if using a custom domain)
3. Wait for health checks to pass
4. Test all routes on the deployed URL

---

## Quick Status

| Item | Status |
|------|--------|
| AT0M_FIT_FEATURE_EXPANSION.sql | PENDING |
| FULL_PREMIUM_BUILDOUT_SETUP.sql | PENDING |
| FINAL_HARDENING_SETUP.sql | PENDING |
| Storage bucket (progress-photos) | PENDING |
| GMAIL_USER secret | PENDING |
| GMAIL_APP_PASSWORD secret | PENDING |
| NOTIFICATION_TO_EMAIL secret | PENDING |
| OPENAI_API_KEY secret | PENDING |
| Legal page review | PENDING |
| Deployment | PENDING |
