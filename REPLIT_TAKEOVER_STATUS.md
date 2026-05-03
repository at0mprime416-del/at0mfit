# REPLIT TAKEOVER STATUS — COMPLETE

## ✅ All Routes Ported and Verified

The `master` branch static HTML production site has been fully imported into Replit.
All 6 routes are live and rendering correctly with the original AT0M FIT brand.

---

## Route Status

| Route        | Status | Source                              |
|--------------|--------|-------------------------------------|
| `/`          | ✅ PASS | React/Vite port of main-branch waitlist landing page |
| `/blueprint` | ✅ PASS | Static HTML from master branch      |
| `/calculator`| ✅ PASS | Static HTML from master branch      |
| `/training`  | ✅ PASS | Static HTML from master branch      |
| `/portal`    | ✅ PASS | Static HTML from master branch      |
| `/coach`     | ✅ PASS | Static HTML from master branch      |

---

## How Static Routes Are Served

Static HTML pages live in `artifacts/at0mfit-web/public/` and are served by a
Vite middleware plugin (`staticHtmlRewritePlugin`) in `vite.config.ts` that rewrites
clean paths to their `.html` files:

- `/blueprint` → `/blueprint.html`
- `/calculator` → `/calculator.html`
- `/training` → `/training.html`
- `/portal` → `/portal.html`
- `/coach` → `/coach.html`

All 15 image assets are in `public/` and resolve correctly via relative paths.

---

## Handoff Docs

All handoff documentation has been imported from `master`:

| File | Location |
|------|----------|
| `REPLIT-HANDOFF.md` | Repo root |
| `handoff/README.md` | Handoff index |
| `handoff/BRAND_GUIDE.md` | Brand guide |
| `handoff/CLIENT_WORKFLOW.md` | Client workflow |
| `handoff/COACH_WORKFLOW.md` | Coach workflow |
| `handoff/CURRENT_STATE.md` | App current state |
| `handoff/DECISIONS_LOG.md` | Decision log |
| `handoff/KNOWN_BUGS_AND_RISKS.md` | Known issues |
| `handoff/PRODUCT_OFFER_BRIEF.md` | Product brief |
| `handoff/REMAINING_BUILDOUT_TASKS.md` | Remaining tasks |
| `handoff/REPLIT_OPERATING_PACK.md` | Replit ops pack |
| `handoff/docs/ROUTE_MAP.md` | Route map |
| `handoff/docs/API_INTEGRATION_MAP.md` | API map |
| `handoff/docs/FIRST_REPLIT_AGENT_PROMPT.md` | First agent prompt |
| `handoff/docs/REPLIT_IMPORT_STEPS.md` | Import steps |
| `handoff/sql/*.sql` | 5 SQL migration files |
| `handoff/env/.env.example` | Required env vars |
| `handoff/assets/ASSET_MAP.md` | Asset map |

---

## Supabase / Secrets

| Secret | Status |
|--------|--------|
| `VITE_SUPABASE_URL` | ✅ Configured |
| `VITE_SUPABASE_ANON_KEY` | ✅ Configured |
| `GMAIL_USER` | ⚠️ Not yet set — needed for waitlist confirmation emails |
| `GMAIL_APP_PASSWORD` | ⚠️ Not yet set — needed for waitlist confirmation emails |

---

## Production Vercel

**NOT touched.** Production remains on Vercel, unchanged.

---

## What Still Needs Work (per handoff docs)

See `handoff/REMAINING_BUILDOUT_TASKS.md` for the full prioritized list.
Key items from `handoff/KNOWN_BUGS_AND_RISKS.md`:
- Portal / coach Supabase auth (sign-in forms are static HTML — need backend wiring)
- Calculator results are client-side JS only — no persistence
- Blueprint purchase flow (Stripe or payment link) not yet wired in Replit
- `GMAIL_USER` / `GMAIL_APP_PASSWORD` secrets still needed for email confirmation
