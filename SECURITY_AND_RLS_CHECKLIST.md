# AT0M FIT — Security and RLS Checklist

**Last updated:** 2026-05-03
**Status:** CORE SECURITY COMPLETE — Owner SQL steps pending

---

## Security Principles Enforced

| Rule | Status |
|------|--------|
| No service role key in frontend HTML | PASS |
| RLS enabled on all core tables | PASS |
| Coach access gated by email JWT claim | PASS |
| Client access scoped to own rows (auth.uid()) | PASS |
| Supabase anon key only exposed in frontend | PASS |
| No RLS disabled on any table | PASS |
| No hardcoded passwords or secrets in source | PASS |
| Vercel production untouched | PASS |
| No emojis in production UI | PASS |

---

## RLS Policy Coverage

### Applied in FULL_PREMIUM_BUILDOUT_SETUP.sql + AT0M_FIT_FEATURE_EXPANSION.sql

| Table | Client Policy | Coach Policy |
|-------|--------------|-------------|
| clients | Read own row | Read all |
| applications | Insert own | Read all, Update all |
| workouts | Read own | Insert for any client |
| assigned_workouts | Read own | Insert all, Read all |
| workout_logs | Insert own, Read own | Read all |
| programs | Read own | Insert, Read all |
| messages | Insert (client), Read own | Insert (coach), Read all |
| checkins | Insert own, Read own | Read all |
| coach_notes | Read own | Manage all |
| progress_photos | Insert own, Read own | Read all |
| nutrition_plans | Read own | Insert all, Read all |
| client_goals | Read own | Insert all, Read all |
| weekly_plan_items | Read own | Insert all, Read all |
| readiness_scores | Insert own, Read own | Read all |
| resource_vault | Read all (SELECT) | Manage all |
| community_posts | Insert own, Read visible | Read all, Update all (moderation) |
| community_comments | Insert own, Read visible | Read all, Update all (moderation) |
| community_reactions | Insert own | Read all |
| ask_atom_logs | Insert own, Read own | Read all, Update (reviewed flag) |

### Applied in FINAL_HARDENING_SETUP.sql (PENDING OWNER)

| Table | Client Policy | Coach Policy |
|-------|--------------|-------------|
| client_onboarding_tasks | Read own, Update own | Read all, Insert |
| support_requests | Insert (public), Read own | Read all, Update |
| client_admin_status | None (coach only) | Full CRUD |
| activity_log | None (coach only) | Read all |
| legal_acceptances | Insert own, Read own | Read all |

---

## Coach Email Gate

The coach dashboard (`/coach`) is gated by:
1. Supabase Auth login required
2. Email must exactly match: `jeshua@levioperations.com`
3. All coach RLS policies use: `auth.jwt() ->> 'email' = 'jeshua@levioperations.com'`

To add a secondary coach, add additional policies or update the email check.

---

## Frontend Secrets Exposure Audit

| Secret | Location | Safe? | Notes |
|--------|---------|-------|-------|
| Supabase anon key | HTML files (hardcoded) | YES | Anon key is designed to be public; all access controlled by RLS |
| Supabase URL | HTML files (hardcoded) | YES | Public URL |
| GMAIL_USER | API server env var only | YES | Never in frontend |
| GMAIL_APP_PASSWORD | API server env var only | YES | Never in frontend |
| OPENAI_API_KEY | API server env var only | YES | Never in frontend |
| NOTIFICATION_TO_EMAIL | API server env var only | YES | Never in frontend |

---

## Known Gaps (Pending Owner Action)

1. `FINAL_HARDENING_SETUP.sql` not yet run — tables and policies not in effect
2. Storage bucket RLS for progress-photos not yet applied
3. Legal acceptance not logged at registration (requires waiver finalization)
4. No rate limiting on `/api/ask-atom` (low priority for MVP)

---

## Production Hardening (Post-MVP)

When ready to harden for production:
1. Add rate limiting middleware to API routes (express-rate-limit)
2. Add request logging and monitoring (e.g., Sentry)
3. Set up Supabase email verification (require verified email before portal access)
4. Consider adding webhook signature validation for any webhook integrations
5. Review and set appropriate Supabase auth settings (OTP expiry, session duration)
