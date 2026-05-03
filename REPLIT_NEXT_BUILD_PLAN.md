# REPLIT NEXT BUILD PLAN

**Last updated:** 2026-05-03
**Current status:** Full premium buildout complete. 7 routes live.

---

## Completed This Sprint

- [x] All 7 routes live (/, /blueprint, /calculator, /training, /portal, /coach, /community)
- [x] /portal — 12-tab full dashboard
- [x] Progress photos upload + history (portal) + view (coach)
- [x] Nutrition plan view (portal) + create/update (coach)
- [x] Weekly calendar 7-day view + filters (portal) + assign (coach)
- [x] Goal tracker / phase meter (portal) + set/update (coach)
- [x] Readiness score form (portal) — 5 sliders, %, recommendation
- [x] Resource vault — 8 guide cards (portal)
- [x] Community tab (portal link) + full /community page
- [x] Ask AT0M — POST /api/ask-atom (OpenAI + safety filter + contextual fallback)
- [x] POST /api/notify-coach — all submission events wired
- [x] Coach email notification: waitlist, application, check-in, workout log, message, photo, community post, readiness, Ask AT0M
- [x] AT0M_FIT_FEATURE_EXPANSION.sql
- [x] FULL_PREMIUM_BUILDOUT_SETUP.sql
- [x] FULL_PREMIUM_BUILDOUT_STATUS.md
- [x] .env.example updated with OPENAI_API_KEY

---

## Next Priority Queue

### P1 — High Value, Owner-Unblocked

| Item | Effort | Notes |
|------|--------|-------|
| Set GMAIL secrets + OPENAI_API_KEY | Owner action | Unlocks real coach emails + AI answers |
| Run both SQL files in Supabase | Owner action | Unlocks all new feature data |
| Create progress-photos storage bucket | Owner action | Unlocks photo uploads |
| Coach moderation tab for community | Medium | View/flag/delete posts from /coach |
| Streaks display (portal Today tab) | Medium | Aggregate workout_logs count per week |
| Badges display (portal) | Small | client_badges table + display cards |
| Weekly report view (portal + coach) | Medium | weekly_reports table ready |

### P2 — Coach Command Center Expansion

| Item | Notes |
|------|-------|
| Coach tab restructure with full tab nav | 10 tabs: Today, Applications, Clients, Programming, Nutrition, Calendar, Progress, Goals, Community, Ops |
| Coach alerts panel | coach_alerts table ready |
| Resource vault management (coach) | resource_vault table ready — coach creates, portal reads |
| Exercise library (coach + portal) | exercise_library table ready |
| Ask AT0M logs in coach dashboard | ask_atom_logs — view questions, flag risky responses |
| Weekly reports generation | Auto-generate from workout_logs + checkins per client |

### P3 — Advanced

| Item | Notes |
|------|-------|
| Coach "Accept Application" → create client | Needs service role key server-side |
| Stripe billing integration | When 10+ clients |
| Password reset flow | sb.auth.resetPasswordForEmail() |
| Mobile app | Separate Expo artifact |
| E2E automated test run | Testing skill |

---

## What NOT to Touch

- Supabase RLS policies — never disable
- Production Vercel — do not touch
- Supabase service_role key — never expose in frontend
- Existing waitlist table data
