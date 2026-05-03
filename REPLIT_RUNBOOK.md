# REPLIT RUNBOOK

## ⛔ Read First

The current Replit import contains the `main` branch (landing page only).
The full multi-route app is on the `master` branch.
**Re-import from `master` before following this runbook for the full app.**

---

## How to Run Locally in Replit

The app runs via Replit workflows — do NOT use `pnpm dev` at the workspace root.

### Start / Restart the Frontend
In the Replit sidebar, the workflow `artifacts/at0mfit-web: web` controls the Vite dev server.
Click the workflow to restart it, or use the shell:
```
# Do NOT run this at workspace root — use the workflow instead
pnpm --filter @workspace/at0mfit-web run dev
```

### Start / Restart the API Server
The workflow `artifacts/api-server: API Server` controls the Express backend.
```
# Do NOT run this at workspace root — use the workflow instead
pnpm --filter @workspace/api-server run dev
```

### Check Workflow Logs
Each workflow streams logs in the Replit console. If a route is broken, check the
console for that workflow first.

---

## How to Test Routes

Once the app is running, open the Replit preview pane (top right) and test each route:

| Route | What to check |
|-------|---------------|
| `/` | Landing page renders, waitlist form is visible |
| `/blueprint` | Page renders, no 404 |
| `/calculator` | Page renders, inputs work |
| `/training` | Page renders, no 404 |
| `/portal` | Login/auth page renders |
| `/coach` | Coach interface renders (may need to be logged in) |

For the API endpoint:
```bash
# Health check
curl http://localhost:80/api/healthz

# Waitlist email (test only — will try to send real email if GMAIL creds set)
curl -X POST http://localhost:80/api/waitlist-confirm \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com"}'
```

---

## How to Add Secrets

1. In Replit, click the **Secrets** tab (lock icon in left sidebar)
2. Add each key-value pair from `.env.example`
3. After adding secrets, **restart affected workflows** so they pick up the new values
4. Never paste secrets into code files or commit them to git

### Required Secrets for Full Functionality

| Secret | Where Used | Required? |
|--------|-----------|-----------|
| `VITE_SUPABASE_URL` | Frontend — Supabase client | YES |
| `VITE_SUPABASE_ANON_KEY` | Frontend — Supabase client | YES |
| `GMAIL_USER` | API server — waitlist emails | For email only |
| `GMAIL_APP_PASSWORD` | API server — waitlist emails | For email only |

---

## How to Continue Buildout Tomorrow

1. **Verify the correct branch is imported** — check for `REPLIT-HANDOFF.md` and all 6 routes
2. Pick up from `REPLIT_NEXT_BUILD_PLAN.md` — start at the highest uncompleted priority
3. Add any missing secrets before testing authenticated flows
4. Use the Replit preview to verify each route visually before marking it done
5. Never run `pnpm dev` at workspace root — always use per-artifact commands or workflows

### Key File Locations

| File | Purpose |
|------|---------|
| `artifacts/at0mfit-web/src/pages/` | All page components |
| `artifacts/at0mfit-web/src/App.tsx` | Router — add new routes here |
| `artifacts/api-server/src/routes/` | Express API routes |
| `lib/api-spec/openapi.yaml` | API contract (OpenAPI) |
| `.env.example` | All required env var names |

---

## How to Avoid Touching Production

- **Never run `vercel deploy` or `vercel --prod`** from this environment
- **Never modify Supabase RLS policies** — only query through the anon key
- **Never disable Supabase Row Level Security**
- **Never use the Supabase `service_role` key in frontend code**
- Treat Vercel + Supabase + Gumroad as read-only dependencies
- All new features should be built and tested in Replit first
- Only switch production to Replit after full route verification + owner sign-off

---

## Architecture Overview

```
artifacts/at0mfit-web/     — Vite + React frontend (serves all pages)
artifacts/api-server/      — Express backend (serves /api/* routes)
lib/api-spec/              — OpenAPI contract
lib/db/                    — Drizzle ORM + Postgres schema (if needed)
```

Routing is handled by a shared reverse proxy:
- `/api/*` → Express API server
- `/*` → Vite React app

All traffic in Replit goes through `localhost:80` (the shared proxy).
