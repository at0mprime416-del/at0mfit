# AT0M FIT — Decisions Log
**All key decisions made during the OpenClaw build phase**

---

## Architecture Decisions

| Decision | Choice | Reason |
|----------|--------|--------|
| Framework | Static HTML (no framework) | Fastest to build, no dependencies, Vercel-native |
| Database | Supabase (PostgreSQL + auth) | Free tier, RLS, JS SDK, no server needed |
| Hosting | Vercel | Instant deploys, free tier, custom domain |
| Checkout | Gumroad (Blueprint only) | Zero setup, instant digital delivery |
| Billing | Manual for first 10 clients | Stripe overhead not worth it at <10 clients |
| Stripe | Deferred | Activate when 10+ clients reached |
| Mobile app | Expo / React Native | Cross-platform, Supabase-compatible |
| Server-side code | None (for now) | Static HTML + Supabase JS SDK is sufficient |

## Product Decisions

| Decision | Choice | Reason |
|----------|--------|--------|
| Founding price | $199/month | Premium positioning, founding discount |
| Blueprint price | $27 | Low barrier to entry, qualifies buyers |
| Calculator | Free | Lead gen, SEO, trust builder |
| Client capacity | Manual until 10 | No infrastructure needed at this scale |
| 8-week program | Deferred | Not a current bottleneck |
| Coaching model | Async (portal + messages) | Scalable, fits SWAT schedule |

## Security Decisions

| Decision | Choice | Reason |
|----------|--------|--------|
| Coach gate | Email check (client-side) + RLS (DB-side) | Belt-and-suspenders — RLS is the real enforcement |
| Anon key exposure | Accepted | By design — anon key is public, RLS enforces access |
| Service role key | Never in frontend | Non-negotiable — would bypass all RLS |
| Client account creation | Manual (Supabase dashboard) | Signups disabled, coach creates manually |
| Signups disabled | Intentional | Founding client phase — invite-only |

## Build Decisions

| Decision | Choice | Reason |
|----------|--------|--------|
| Inline CSS/JS | Yes (per page) | No build step needed, fully self-contained pages |
| CDN dependencies | Supabase JS, Google Fonts | No npm needed for web site |
| workouts.user_id | = client's auth UUID | Coach sets this on assignment; client queries by auth.uid() |
| PostgREST restart | Required after ALTER TABLE | Column cache doesn't update without hard restart |
| applications.created_at | Added as patch | Original schema had submitted_at only; coach.html queries created_at |
| checkins.created_at | Added as patch | Same reason |

## Migration Decisions (OpenClaw → Replit)

| Decision | Choice | Reason |
|----------|--------|--------|
| What Replit replaces | Build workspace only | No need to replace Supabase/Vercel/Gumroad |
| What stays on OpenClaw | Ezra, Pulse, Deborah | Personal automations unrelated to AT0M FIT |
| Dead crons killed | doc_push, calendar_brief | Low value / file missing |
| Handoff format | Structured file package | Replit needs files, not screenshots |
| OpenClaw shutdown trigger | After Replit confirms first deploy | Explicit instruction required |

---

## Known Trade-offs Accepted

1. **Coach email gate is client-side** — a technically advanced attacker could bypass the UI gate. The Supabase RLS is the real security. Accepted for founding phase.

2. **No automated client onboarding** — Jeshua creates accounts manually. Adds ~5 minutes per client. Acceptable at <10 clients.

3. **No Stripe recurring billing** — manual payment collection for now. Adds admin overhead but removes integration complexity.

4. **Anon key in HTML source** — visible to anyone who views source. This is standard practice for Supabase; the key only grants what RLS permits.

5. **Single coach email hardcoded** — if Levi ever changes his coaching email or adds a second coach, every RLS policy and the coach.html gate must be updated.
