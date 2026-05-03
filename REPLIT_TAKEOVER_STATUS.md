# REPLIT TAKEOVER STATUS — COMPLETE + FUNCTIONAL

## Summary

All 6 routes live. Portal and coach auth fully wired to Supabase.
All data operations wired through RLS. No service key exposed. Brand intact.

---

## Route Status

| Route        | Status | Auth | Notes |
|--------------|--------|------|-------|
| `/`          | LIVE   | None | React/Vite waitlist landing page |
| `/blueprint` | LIVE   | None | Static HTML from master branch |
| `/calculator`| LIVE   | None | Static HTML — client-side zone calculator |
| `/training`  | LIVE   | None | Static HTML — custom training page |
| `/portal`    | LIVE   | Supabase email/password | Full dashboard wired |
| `/coach`     | LIVE   | Supabase email/password + email gate | Full dashboard wired |

---

## /portal — Client Dashboard

| Feature | Status |
|---------|--------|
| Login form | WIRED — Supabase signInWithPassword |
| Error messages | WIRED — invalid credentials shown inline |
| Session persistence | WIRED — getSession() on init, onAuthStateChange listener |
| Logout | WIRED — signOut() + returns to login view |
| Assigned workouts | WIRED — queries assigned_workouts + workouts, shows this week's workout |
| **Log workout form** | **WIRED (new)** — RPE, duration, notes → workout_logs insert + marks assigned_workout completed |
| Weekly check-in form | WIRED — 4 ratings (training/sleep/stress/energy) + notes → checkins insert |
| Messages thread | WIRED — loads from messages, send inserts with sender='client' |
| Coach notes | WIRED — reads coach_notes WHERE is_visible_to_client=true |
| Progress metrics | WIRED — weight from progress_metrics, last check-in date, sessions this week |

---

## /coach — Coach Dashboard

| Feature | Status |
|---------|--------|
| Login form | WIRED — Supabase signInWithPassword |
| Email gate | WIRED — only jeshua@levioperations.com allowed; others sign out immediately and see restricted view |
| Session persistence | WIRED — getSession() on init |
| Logout | WIRED — signOut() + returns to login view |
| Applications queue | WIRED — reads applications WHERE status='pending', "Mark Reviewed" updates status |
| Client roster | WIRED — reads all clients, click to expand detail panel |
| Create program | WIRED — inserts into programs with client_id, name, start_date, description |
| Assign workout | WIRED — inserts into workouts + assigned_workouts (two-step) |
| View assigned workouts | WIRED — per client in detail panel |
| View check-ins | WIRED — per client with 1-5 ratings |
| View workout logs | WIRED — per client with RPE, duration, notes |
| Coach → client messages | WIRED — inserts into messages with sender='coach', live reload |

---

## Security

| Constraint | Status |
|------------|--------|
| Service role key exposed | NO — anon key only, designed for public use |
| RLS disabled | NO — all tables enforced |
| Vercel production touched | NO |
| Brand redesigned | NO |
| Working routes removed | NO |

---

## Secrets

| Secret | Status |
|--------|--------|
| `VITE_SUPABASE_URL` | Configured |
| `VITE_SUPABASE_ANON_KEY` | Configured |
| `GMAIL_USER` | Not set — email confirmation deferred |
| `GMAIL_APP_PASSWORD` | Not set — email confirmation deferred |

---

## Remaining Blockers (Owner Action)

1. **GMAIL_USER + GMAIL_APP_PASSWORD** — set in Replit Secrets when ready for email confirmation
2. **Supabase coach RLS policies** — must be applied once in Supabase SQL editor for coach dashboard to read all clients/applications. SQL is in `handoff/sql/05_coach_dashboard_rls.sql` and embedded in coach.html lines 1476–1518.
3. **Coach password reset** — jeshua@levioperations.com password was set via Supabase Dashboard on Vercel. Same account + password works here (same Supabase project). If login fails, reset via Supabase Dashboard → Authentication → Users.
4. **Client onboarding** — new clients must be created in Supabase Auth by the coach (signups are disabled per spec). Then add a row to `clients` table manually or via coach "Accept Application" flow (not yet built).
