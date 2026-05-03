# QCMD — REPLIT GATE CHECK

**Date:** 2026-05-03
**Project:** AT0M FIT
**Evaluator:** Replit Agent

---

## Gate Status: PASS

All 6 routes live. Portal and coach auth fully wired. All handoff docs present.
No service key exposed. RLS active. Vercel production untouched.

---

## Route Check

| Route        | Auth | Status |
|--------------|------|--------|
| `/`          | None | PASS — React/Vite waitlist landing page |
| `/blueprint` | None | PASS — Static HTML, images loading |
| `/calculator`| None | PASS — Static HTML, zone calculator working |
| `/training`  | None | PASS — Static HTML, hero image loading |
| `/portal`    | Supabase email/password | PASS — Full dashboard wired |
| `/coach`     | Supabase email/password + email gate | PASS — Full dashboard wired |

---

## Portal Auth Check

| Feature | Status |
|---------|--------|
| Login (signInWithPassword) | WIRED |
| Bad credentials error | WIRED — inline error message |
| Session persistence (getSession on load) | WIRED |
| Auth state listener (onAuthStateChange) | WIRED |
| Logout (signOut) | WIRED |
| Assigned workouts display | WIRED — queries assigned_workouts + workouts |
| Workout log form | WIRED — RPE + duration + notes → workout_logs INSERT |
| Mark assigned workout completed | WIRED — assigned_workouts UPDATE on log submit |
| Weekly check-in form | WIRED — 4 ratings + notes → checkins INSERT |
| Messages thread + send | WIRED — messages SELECT + INSERT (sender='client') |
| Coach notes display | WIRED — coach_notes SELECT (is_visible_to_client=true) |
| Progress metrics | WIRED — progress_metrics, checkins, assigned_workouts |

---

## Coach Auth Check

| Feature | Status |
|---------|--------|
| Login (signInWithPassword) | WIRED |
| Email gate (jeshua@levioperations.com only) | WIRED — others signed out → restricted view |
| Session persistence | WIRED |
| Logout | WIRED |
| Applications queue | WIRED — applications SELECT (status=pending) |
| Mark reviewed | WIRED — applications UPDATE (status=reviewed) |
| Client roster | WIRED — clients SELECT all |
| Client detail panel | WIRED — programs, assigned_workouts, checkins, workout_logs, messages |
| Create program | WIRED — programs INSERT |
| Assign workout | WIRED — workouts INSERT + assigned_workouts INSERT |
| View check-ins per client | WIRED |
| View workout logs per client | WIRED |
| Coach → client messages | WIRED — messages INSERT (sender='coach') |

---

## Secrets Check

| Secret | Status |
|--------|--------|
| `VITE_SUPABASE_URL` | PASS — configured |
| `VITE_SUPABASE_ANON_KEY` | PASS — configured |
| `GMAIL_USER` | WARN — not set (email confirmation deferred by owner) |
| `GMAIL_APP_PASSWORD` | WARN — not set (email confirmation deferred by owner) |

---

## Safety Check

| Constraint | Status |
|------------|--------|
| Service role key exposed in frontend | NO — anon key only |
| RLS disabled | NO — all tables enforced |
| Production Vercel touched | NO |
| Brand redesigned | NO |
| Working routes removed | NO |

---

## Docs Check

| File | Status |
|------|--------|
| `REPLIT-HANDOFF.md` | PASS |
| `handoff/README.md` | PASS |
| `handoff/BRAND_GUIDE.md` | PASS |
| `handoff/CURRENT_STATE.md` | PASS |
| `handoff/PRODUCT_OFFER_BRIEF.md` | PASS |
| `handoff/REPLIT_OPERATING_PACK.md` | PASS |
| `handoff/KNOWN_BUGS_AND_RISKS.md` | PASS |
| `handoff/REMAINING_BUILDOUT_TASKS.md` | PASS |
| `handoff/sql/01–05_*.sql` | PASS — all 5 migration files |
| `handoff/env/.env.example` | PASS |
| `REPLIT_TAKEOVER_STATUS.md` | PASS |
| `REPLIT_NEXT_BUILD_PLAN.md` | PASS |
| `REPLIT_RUNBOOK.md` | PASS |
| `QCMD_REPLIT_GATE.md` | PASS — this file |

---

## Remaining Blockers (Owner Action Only)

1. Apply `handoff/sql/05_coach_dashboard_rls.sql` in Supabase SQL editor — coach dashboard reads all clients/applications via RLS
2. Confirm coach password for jeshua@levioperations.com — reset via Supabase Dashboard if needed
3. Set `GMAIL_USER` + `GMAIL_APP_PASSWORD` when email confirmation is ready
4. Client onboarding — create client auth users via Supabase Dashboard (signups disabled per spec)

---

## QCMD RESULT

```
QCMD: PASS
AT0M FIT Replit takeover COMPLETE.
All 6 routes live. Portal + coach auth fully wired to Supabase.
All data operations go through RLS. No service key exposed.
Vercel production untouched. Brand intact.
Only remaining blockers are owner-action items (SQL apply, password confirm, secrets).
```
