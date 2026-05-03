# REPLIT NEXT BUILD PLAN

**Last updated:** 2026-05-03
**Current status:** All 6 routes live. Portal + coach auth fully wired.

---

## Completed

- [x] All 6 routes ported from master branch (blueprint, calculator, training, portal, coach)
- [x] All 15 image assets in public/
- [x] All handoff docs imported (handoff/ directory)
- [x] /portal Supabase auth (login, session persistence, logout, error messages)
- [x] /portal assigned workouts display
- [x] /portal workout log form — RPE + duration + notes → workout_logs insert
- [x] /portal weekly check-in form — 4 ratings + notes → checkins insert
- [x] /portal messages thread + client send
- [x] /portal coach notes display
- [x] /portal progress metrics (weight, last check-in, sessions)
- [x] /coach auth with email gate (jeshua@levioperations.com only)
- [x] /coach applications queue + mark reviewed
- [x] /coach client roster with detail panel
- [x] /coach create program
- [x] /coach assign workout (creates workout row + assigned_workout row)
- [x] /coach view assigned workouts per client
- [x] /coach view check-ins per client
- [x] /coach view workout logs per client
- [x] /coach coach → client messages

---

## Priority Queue

### P1 — Functional Gaps (Small effort, high value)

| Item | Effort | Notes |
|------|--------|-------|
| Portal check-in history view | Small | Data exists in DB; display card not built in portal sidebar |
| Portal workout log history | Small | Logs exist; no display card |
| Coach "Add Note" form | Small | coach_notes table ready, no UI |
| Password reset flow | Small | Add "Forgot password?" → sb.auth.resetPasswordForEmail() |

### P2 — Owner Actions (Blockers needing credentials)

| Item | Notes |
|------|-------|
| Set GMAIL_USER + GMAIL_APP_PASSWORD secrets | Enables waitlist email confirmation |
| Apply 05_coach_dashboard_rls.sql | Run once in Supabase SQL editor — unlocks coach reads of all clients/applications |
| Coach account password reset | If login fails: Supabase Dashboard → Auth → Users → jeshua@levioperations.com → Reset password |
| Client onboarding | Create client in Supabase Auth manually, then add row to clients table |

### P3 — Deferred

| Item | Notes |
|------|-------|
| Coach "Accept Application" → create client auth user | Needs service role key (server-side only) |
| Stripe billing | Deferred until 10+ clients |
| Application form E2E browser test | Not yet tested in live Replit environment |
| Mobile app integration | Separate artifact |

---

## What NOT to Touch

- Supabase RLS policies — never disable
- Production Vercel — do not touch until Replit is fully verified and owner signs off
- Supabase service_role key — never expose in frontend
- Existing waitlist table data
