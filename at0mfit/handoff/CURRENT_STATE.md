# AT0M FIT — Current State
**As of:** 2026-05-03

---

## Live Routes — All Confirmed 200 OK

| Route | File | Status |
|-------|------|--------|
| `/` | index.html | ✅ Live |
| `/blueprint` | blueprint.html | ✅ Live |
| `/calculator` | calculator.html | ✅ Live |
| `/training` | training.html | ✅ Live |
| `/portal` | portal.html | ✅ Live |
| `/coach` | coach.html | ✅ Live |

## QA Test Results (2026-05-02 — 24/24 PASS)

| Check | Result |
|-------|--------|
| /coach page loads | ✅ |
| /portal page loads | ✅ |
| Service key NOT in coach.html | ✅ |
| Service key NOT in portal.html | ✅ |
| Coach login (jeshua@levioperations.com) | ✅ |
| Non-coach cannot see other clients (RLS) | ✅ |
| Non-coach cannot read applications table | ✅ |
| Applications queue loads for coach | ✅ |
| Client roster loads for coach | ✅ |
| Create program | ✅ |
| Workout inserted (all 5 new columns) | ✅ |
| assigned_workout row created | ✅ |
| Client portal login | ✅ |
| Assigned workout visible in portal | ✅ |
| Workout has all 5 schema columns | ✅ |
| Workout log submitted by client | ✅ |
| Client check-in submitted | ✅ |
| Client → coach message sent | ✅ |
| Coach → client message sent | ✅ |
| Client sees coach message in thread | ✅ |
| Coach sees client message in thread | ✅ |
| Coach reads client check-ins | ✅ |
| Coach reads client workout logs | ✅ |
| QA test data cleaned up | ✅ |

---

## Database State

- **Project:** kgozddcutazpqmfbzafa.supabase.co
- **Tables:** 37 live tables
- **RLS:** Enabled on all tables
- **Auth:** Email/password, signups disabled (intentional)
- **Coach account:** jeshua@levioperations.com (password set via DB — needs reset via Supabase Dashboard)

## GitHub State

- **Repo:** at0mprime416-del/at0mfit
- **Branch `master`:** Current production codebase — all changes pushed
- **Branch `main`:** Old Next.js prototype — do not use
- **Last commit:** Remove emojis — brand-appropriate markers pass (2026-05-03)

## Deployment State

- **Production:** Deployed via `vercel deploy --prod` (direct)
- **Auto-deploy:** GitHub push triggers preview-only (not production)
- **Fix available:** Change Vercel production branch from `main` to `master` in Vercel Dashboard

---

## What Is Working

- All 6 public pages
- Coach dashboard: login, applications, roster, create program, assign workout, messages
- Client portal: login, view workout, log workout, check-in, messaging
- Supabase RLS: client isolation, coach email gate
- Applications intake form (anon INSERT)

## What Is NOT Working / Not Built

| Feature | Status |
|---------|--------|
| Coach "Accept Application" button | Not built — manual process |
| Coach "Add Note" form | Not built — DB ready, no UI |
| Portal check-in history view | Not built — submit works, display missing |
| Portal workout log history | Not built — same |
| Stripe billing | Not integrated — deferred to 10+ clients |
| Client onboarding email | Not built |
| Password reset flow | Untested |
| Application form end-to-end browser test | Not tested in live browser |
| Waitlist form | Not tested |
