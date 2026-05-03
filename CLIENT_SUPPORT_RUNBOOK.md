# AT0M FIT — Client Support Runbook

**Owner:** Jeshua — Levi Operations LLC
**Last updated:** 2026-05-03

---

## Support Channels

| Channel | How Clients Access | Response SLA |
|---------|--------------------|-------------|
| In-portal Help tab | /portal > Help tab (form) | 1 business day |
| /support page | Direct URL, accessible without login | 1 business day |
| Direct email | jeshua@levioperations.com | Coach discretion |
| Coach message | /portal > Messages tab | During coaching hours |

---

## When Gmail Secrets Are Configured

Support requests submitted via `/support` or the portal Help tab will:
1. Insert a record into `support_requests` table in Supabase
2. Send a notification email to `NOTIFICATION_TO_EMAIL` via Gmail
3. Email includes: client name, email, issue type, full message

**Check Supabase** > `support_requests` table for all submitted requests.

---

## Issue Type Responses

| Issue Type | First Response |
|-----------|---------------|
| Technical Issue | Check if Supabase tables are set up. Check browser console for errors. |
| Coaching Question | Respond via Messages tab in coach dashboard |
| Billing / Subscription | Handle outside platform until payment system is set up |
| Account Access | Reset password via Supabase Auth > Users |
| Feedback | Log for future development consideration |
| Cancellation Request | Process manually; remove client subscription status |
| Data / Privacy Request | Respond within 30 days; delete via Supabase Auth > Users |

---

## Coach Dashboard Quick Actions

From `/coach` > Client detail panel:
- **Send message**: Messages section in client detail
- **Update goal**: Goal Tracker section
- **Update nutrition**: Nutrition Plan section
- **Add calendar item**: Weekly Calendar section
- **View check-ins**: Check-in History section
- **View risk flags**: Risk / Attention Panel at bottom of coach dashboard

---

## Safety Protocol

If a client reports:
- Medical emergency: Advise 911 immediately. Do not delay.
- Injury: Advise stopping training and seeing a physician. Document in coach notes.
- Mental health concern: Refer to appropriate crisis resources (988 Suicide and Crisis Lifeline).
- Extreme dietary behavior: Refer to physician or registered dietitian. Pause nutrition coaching.

Log any safety incident in the client's coach notes section with date and action taken.

---

## Account Management

### Reset a Client Password
1. Go to Supabase > Authentication > Users
2. Find the user by email
3. Click the user > Send Password Reset Email

### Delete a Client Account
1. Supabase > Authentication > Users > Find user > Delete
2. All their data will cascade-delete (where ON DELETE CASCADE is set)
3. Remove from any manual billing records

### Add a New Client
Clients self-register via Supabase Auth on the /portal page. After they sign up:
1. A record should auto-appear in the `clients` table (if triggers are set)
2. If not, manually insert into `clients` with their auth UUID
3. Set initial goal, program, and nutrition plan via the coach dashboard

---

## Escalation

If something in the platform is broken:
1. Check `/api/healthz` for API server status
2. Check Replit workflow logs for the API Server and Web workflows
3. Check Supabase for connection errors
4. For code-level issues: contact Replit agent for assistance

---

## Support Request Tracking

Until a formal ticketing system is set up:
- Check `support_requests` table in Supabase for all submissions
- Use `status` column: `open`, `in_progress`, `resolved`
- Update status via Supabase table editor or coach admin panel
