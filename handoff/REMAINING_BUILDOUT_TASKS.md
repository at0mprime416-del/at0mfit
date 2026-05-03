# AT0M FIT — Remaining Buildout Tasks

---

## Priority Order

### P0 — Immediate (Before First Client)

| # | Task | File | Notes |
|---|------|------|-------|
| 1 | Reset coach password | Supabase Dashboard | Authentication → Users → jeshua@levioperations.com → Reset password |
| 2 | Fix Vercel production branch | Vercel Dashboard | Change production branch from `main` to `master` so GitHub push auto-deploys |

---

### P1 — High Priority (Unblocks Core Workflow)

| # | Task | File | Notes |
|---|------|------|-------|
| 3 | Coach "Add Note" form | coach.html | DB table `coach_notes` exists. Need UI: text input + submit inside each client panel |
| 4 | Coach "Accept Application" → create client | coach.html + server endpoint | Needs service role key server-side (Vercel function or Replit endpoint). Creates auth user + clients row |
| 5 | Application form end-to-end browser test | training.html | Modal submit flow needs live browser test (unit tested via API only) |

---

### P2 — Medium Priority (Improves Client Experience)

| # | Task | File | Notes |
|---|------|------|-------|
| 6 | Portal: check-in history view | portal.html | Query: `checkins WHERE client_id = user.id ORDER BY week_of DESC LIMIT 4`. Display as cards below submit form |
| 7 | Portal: workout log history | portal.html | Query: `workout_logs JOIN assigned_workouts JOIN workouts`. Show last 4 with workout name, RPE, date |
| 8 | Client onboarding email | Server-side (Resend) | Triggered when coach accepts application. Send welcome + portal URL + login instructions |
| 9 | Waitlist form test | index.html | Confirm homepage waitlist email submit works end-to-end |

---

### P3 — Low Priority / Deferred

| # | Task | Notes |
|---|------|-------|
| 10 | Stripe billing | Activate at 10+ clients. Create Stripe product ($199/month recurring), add /api/checkout endpoint, add webhook for subscription lifecycle |
| 11 | Coach progress metrics entry | Add form to enter weight, resting HR, VO2 for each client (progress_metrics table) |
| 12 | Coach: mark workout completed | Allow coach to mark assigned_workouts.completed = true |
| 13 | Password reset email test | Test Supabase recovery email flow — verify SMTP config is working |

---

### Future (Not Started)

| # | Task | Notes |
|---|------|-------|
| 14 | 8-Week Program product | Full program structure + purchase flow. Defer until explicitly instructed |
| 15 | Social media assets | Quote cards, workout tips, program announcements |
| 16 | New application notification | Supabase webhook → Resend email to coach when new application submitted |
| 17 | Mobile app: App Store submission | Expo EAS build → TestFlight → App Store review |

---

## Replit Should Build First

**Task 3** (Coach Add Note form) — smallest lift, high value for client relationship

**Task 6 + 7** (Portal history views) — client experience improvement, no new infrastructure needed

**Task 4** (Accept application flow) — higher complexity (needs server-side endpoint), but unblocks growth

---

## What Replit Should NOT Touch

- Supabase RLS policies (unless explicitly asked)
- `workouts` table schema (already patched and working)
- The Gumroad checkout flow (not our system)
- Production database data
- The `main` branch on GitHub (old Next.js prototype, ignore)
