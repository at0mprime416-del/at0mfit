# REPLIT RUNBOOK

**Last updated:** 2026-05-03
**Status:** Full premium buildout complete. 7 routes live.

---

## Workflows

| Workflow | Command | Purpose |
|----------|---------|---------|
| `artifacts/at0mfit-web: web` | `pnpm --filter @workspace/at0mfit-web run dev` | Vite dev server — all 7 routes |
| `artifacts/api-server: API Server` | `pnpm --filter @workspace/api-server run dev` | Express API — /api/* routes |

Do NOT use `pnpm dev` at the workspace root.

---

## Route Map

| Request | File / Handler |
|---------|----------------|
| `/` | `src/pages/home.tsx` — React waitlist landing |
| `/blueprint` | `public/blueprint.html` |
| `/calculator` | `public/calculator.html` |
| `/training` | `public/training.html` |
| `/portal` | `public/portal.html` — 12-tab client dashboard |
| `/coach` | `public/coach.html` — coach command center |
| `/community` | `public/community.html` — client community |

Static HTML routes are rewritten via `staticHtmlRewritePlugin` in `vite.config.ts`.

---

## API Routes

| Route | Purpose |
|-------|---------|
| `GET /api/healthz` | Health check |
| `POST /api/waitlist-confirm` | Waitlist email confirmation (requires Gmail secrets) |
| `POST /api/notify-coach` | Coach notification email for all submit events |
| `POST /api/ask-atom` | Ask AT0M AI — OpenAI with safety filter + contextual fallback |

---

## How to Test Routes

```bash
# Health check
curl http://localhost:80/api/healthz

# Test notify-coach (will skip email if Gmail not set, returns 200)
curl -X POST http://localhost:80/api/notify-coach \
  -H "Content-Type: application/json" \
  -d '{"type":"Test","client_name":"Test User","client_email":"test@test.com","subject":"Test","summary":"Test notification"}'

# Test ask-atom (returns contextual fallback if no OPENAI_API_KEY)
curl -X POST http://localhost:80/api/ask-atom \
  -H "Content-Type: application/json" \
  -d '{"question":"How do I build my Zone 2 base?"}'
```

---

## Secrets Setup

1. Click the Secrets tab in Replit (lock icon in left sidebar)
2. Add each key-value pair
3. Restart the API Server workflow after adding secrets

| Secret | Used By | Required |
|--------|---------|----------|
| `VITE_SUPABASE_URL` | Frontend + API | YES — configured |
| `VITE_SUPABASE_ANON_KEY` | Frontend + API | YES — configured |
| `GMAIL_USER` | API /api/notify-coach | Optional — skips gracefully if missing |
| `GMAIL_APP_PASSWORD` | API /api/notify-coach | Optional — skips gracefully if missing |
| `NOTIFICATION_TO_EMAIL` | API /api/notify-coach | Optional — defaults to jeshua@levioperations.com |
| `OPENAI_API_KEY` | API /api/ask-atom | Optional — falls back to contextual responses |
| `SUPABASE_SERVICE_ROLE_KEY` | API (future coach accept) | Never in frontend |

---

## Supabase Setup (Owner Must Run)

### Step 1 — SQL Migrations (run in order in Supabase SQL editor)

```
1. AT0M_FIT_FEATURE_EXPANSION.sql
   Creates: progress_photos, nutrition_plans, weekly_plan_items, client_goals

2. FULL_PREMIUM_BUILDOUT_SETUP.sql
   Creates: community_posts, community_comments, community_reactions,
            ask_atom_logs, readiness_scores, client_badges, resource_vault,
            exercise_library, coach_alerts, weekly_reports
```

### Step 2 — Storage Bucket

```
Name: progress-photos
Public: NO (private)
Policies: authenticated users can upload own files; coach can view all
```

### Step 3 — Coach RLS

If coach dashboard shows "Could not load clients/applications":
- Run `handoff/sql/05_coach_dashboard_rls.sql` in Supabase SQL editor

---

## Auth Notes

- Coach login: jeshua@levioperations.com — Supabase Auth account
- Client login: Created in Supabase Auth by coach (signups disabled)
- If coach login fails: Supabase Dashboard → Authentication → Users → reset password

---

## Architecture

```
artifacts/at0mfit-web/
  public/               — Static HTML (portal, coach, community, blueprint, calculator, training)
  public/images/        — All brand image assets
  src/pages/home.tsx    — React waitlist landing page (/)
  vite.config.ts        — staticHtmlRewritePlugin + /community route

artifacts/api-server/
  src/routes/
    health.ts           — GET /api/healthz
    waitlist-confirm.ts — POST /api/waitlist-confirm
    notify-coach.ts     — POST /api/notify-coach
    ask-atom.ts         — POST /api/ask-atom
  src/routes/index.ts   — Registers all routes

AT0M_FIT_FEATURE_EXPANSION.sql   — 4 new tables (run first)
FULL_PREMIUM_BUILDOUT_SETUP.sql  — 10 new tables (run second)
FULL_PREMIUM_BUILDOUT_STATUS.md  — Full feature status report
```

---

## Safety Rules

- Never run `vercel deploy` or `vercel --prod` from this environment
- Never modify or disable Supabase RLS policies
- Never use the Supabase service_role key in frontend code
- Never hardcode secrets — use Replit Secrets only
- Production Vercel is untouched — treat as read-only until owner sign-off
