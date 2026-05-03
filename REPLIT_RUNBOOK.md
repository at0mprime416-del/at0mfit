# REPLIT RUNBOOK

**Last updated:** 2026-05-03
**Status:** All routes live. Portal + coach auth fully wired.

---

## How to Run Locally in Replit

The app runs via Replit workflows. Do NOT use `pnpm dev` at the workspace root.

### Start / Restart the Frontend

In the Replit sidebar, the workflow `artifacts/at0mfit-web: web` controls the Vite dev server.
Click the workflow to restart it, or use the shell:
```
pnpm --filter @workspace/at0mfit-web run dev
```

### Start / Restart the API Server

The workflow `artifacts/api-server: API Server` controls the Express backend.
```
pnpm --filter @workspace/api-server run dev
```

---

## How Static HTML Routes Are Served

Static HTML pages live in `artifacts/at0mfit-web/public/`.
A Vite middleware plugin (`staticHtmlRewritePlugin`) in `vite.config.ts` rewrites
clean paths to `.html` files at request time:

| Request | Served File |
|---------|-------------|
| `/blueprint` | `public/blueprint.html` |
| `/calculator` | `public/calculator.html` |
| `/training` | `public/training.html` |
| `/portal` | `public/portal.html` |
| `/coach` | `public/coach.html` |

Images are also in `public/` and resolve via relative paths from the HTML.

---

## How to Test Routes

| Route | What to check |
|-------|---------------|
| `/` | Landing page renders, waitlist form visible |
| `/blueprint` | Zone 2 blueprint page renders, images load |
| `/calculator` | Zone calculator renders, number inputs work |
| `/training` | Custom training page renders, hero image loads |
| `/portal` | Login form shows → sign in with a client account → dashboard loads |
| `/coach` | Login form shows → sign in as jeshua@levioperations.com → coach dashboard loads |

For the API endpoint:
```bash
curl http://localhost:80/api/healthz
```

---

## How to Test Portal Auth

1. Go to `/portal`
2. Enter a client email + password (created in Supabase Auth)
3. On success: dashboard loads with assigned workouts, log form, check-in, messages
4. Sign out: returns to login
5. Refresh: session persists (getSession() on init)
6. Wrong credentials: error shown inline

## How to Test Coach Auth

1. Go to `/coach`
2. Enter `jeshua@levioperations.com` + password
3. On success: applications queue + client roster loads
4. Any other email: signed out immediately, "Unauthorized coach account" shown
5. Sign out: returns to login

---

## How to Add Secrets

1. In Replit, click the Secrets tab (lock icon in left sidebar)
2. Add each key-value pair
3. After adding secrets, restart affected workflows

### Required Secrets

| Secret | Used By | Status |
|--------|---------|--------|
| `VITE_SUPABASE_URL` | Frontend | Configured |
| `VITE_SUPABASE_ANON_KEY` | Frontend | Configured |
| `GMAIL_USER` | API server (waitlist emails) | Not set |
| `GMAIL_APP_PASSWORD` | API server (waitlist emails) | Not set |

---

## Supabase Coach RLS — Apply Once

If the coach dashboard shows "Could not load applications" or "Could not load clients",
the coach RLS policies have not been applied yet. Run this once in Supabase SQL editor:

```
See: handoff/sql/05_coach_dashboard_rls.sql
```

The SQL is also embedded in coach.html lines 1476–1518 as a comment.

---

## Architecture

```
artifacts/at0mfit-web/         — Vite + React frontend + static HTML pages
  public/                      — Static HTML (portal, coach, blueprint, calculator, training)
  public/*.png *.jpg           — All 15 image assets
  src/pages/home.tsx           — React waitlist landing page (/)
  vite.config.ts               — Includes staticHtmlRewritePlugin for clean routes

artifacts/api-server/          — Express backend (serves /api/* routes)
  src/routes/waitlist-confirm  — Email confirmation endpoint

handoff/                       — Full handoff package from original dev
  sql/                         — 5 ordered SQL migration files
  docs/                        — Route map, API map, import steps
  env/.env.example             — Required env var names
```

---

## Safety Rules

- Never run `vercel deploy` or `vercel --prod` from this environment
- Never modify Supabase RLS policies — query only through anon key
- Never disable Supabase Row Level Security
- Never use the Supabase service_role key in frontend code
- Production Vercel is untouched — treat as read-only until owner sign-off
