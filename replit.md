# AT0M FIT — Replit Workspace

## Overview

pnpm workspace monorepo. AT0M FIT is a Zone 2 / hybrid athlete training platform
built by At0m. The production site was a static HTML app on Vercel (master branch).
It has been ported into this Replit workspace with all routes running.

## Artifacts

| Artifact | Path | Description |
|----------|------|-------------|
| `at0mfit-web` | `/` | Vite + React shell serving all AT0M FIT pages |
| `api-server` | `/api` | Express 5 API server |

## Routes

| URL | Source | Notes |
|-----|--------|-------|
| `/` | React (Vite) | Waitlist landing page — Supabase insert |
| `/blueprint` | Static HTML | Zone 2–4 Blueprint product page |
| `/calculator` | Static HTML | Heart Rate Zone Calculator (client-side JS) |
| `/training` | Static HTML | Custom Training sales/apply page |
| `/portal` | Static HTML | Client Portal — 14 tabs (Supabase auth) |
| `/coach` | Static HTML | Coach Dashboard — 9 sections (email-gated) |
| `/community` | Static HTML | Client community (Supabase auth) |
| `/terms` | Static HTML | Terms of Service (draft — needs legal review) |
| `/privacy` | Static HTML | Privacy Policy (draft — needs legal review) |
| `/waiver` | Static HTML | Training Waiver (draft — needs legal review) |
| `/support` | Static HTML | Support form (submits to Supabase + notifies coach) |
| `/launch-checklist` | Static HTML | Internal launch readiness status page |

## Static HTML Routing

Static pages live in `artifacts/at0mfit-web/public/`.
A Vite middleware plugin (`staticHtmlRewritePlugin`) in `vite.config.ts` rewrites
clean paths → `.html` files. Image assets are in `public/assets/` (16 files).
Always reference images as `./assets/filename.ext` (relative path — safe with any base path).

## Stack

- **Monorepo tool**: pnpm workspaces
- **Node.js version**: 24
- **Frontend**: Vite + React + Tailwind (at0mfit-web)
- **API**: Express 5 (api-server)
- **Database**: Supabase (PostgreSQL) — RLS enabled, do NOT disable
- **Auth**: Supabase Auth (portal + coach pages)
- **Email**: Nodemailer via Gmail (waitlist confirmations)

## Required Secrets

| Secret | Used By | Status |
|--------|---------|--------|
| `VITE_SUPABASE_URL` | Frontend | SET |
| `VITE_SUPABASE_ANON_KEY` | Frontend | SET |
| `GMAIL_USER` | API server | NOT SET — graceful skip active |
| `GMAIL_APP_PASSWORD` | API server | NOT SET — graceful skip active |
| `NOTIFICATION_TO_EMAIL` | API server | NOT SET — defaults to jeshua@levioperations.com |
| `OPENAI_API_KEY` | API server | NOT SET — contextual fallback active |

## Key Commands

- `pnpm --filter @workspace/at0mfit-web run dev` — run frontend
- `pnpm --filter @workspace/api-server run dev` — run API server
- `pnpm run typecheck` — typecheck all packages

## Handoff Docs

Full handoff package from original dev is in `handoff/`:
- `handoff/README.md` — index
- `handoff/REMAINING_BUILDOUT_TASKS.md` — what's left to build
- `handoff/KNOWN_BUGS_AND_RISKS.md` — known issues
- `handoff/sql/` — 5 SQL migration files (apply in order)
- `handoff/docs/ROUTE_MAP.md` — full route reference
- `REPLIT-HANDOFF.md` — top-level handoff doc (repo root)

## SQL Setup Files (run in order in Supabase SQL editor)

1. `AT0M_FIT_FEATURE_EXPANSION.sql` — progress_photos, nutrition_plans, weekly_plan_items, client_goals
2. `FULL_PREMIUM_BUILDOUT_SETUP.sql` — community, ask_atom_logs, readiness, resources, and more
3. `FINAL_HARDENING_SETUP.sql` — client_admin_status, support_requests, activity_log, legal_acceptances, onboarding_tasks

See `OWNER_SETUP_CHECKLIST.md` for full setup instructions including storage bucket and secrets.

## Stripe Integration Note

The Replit Stripe connector was dismissed by the owner. Stripe is wired via direct env secrets instead:
- `STRIPE_SECRET_KEY` — your Stripe secret key (sk_live_... or sk_test_...)
- `STRIPE_WEBHOOK_SECRET` — your Stripe webhook signing secret (whsec_...)

`stripeClient.ts` reads these directly from `process.env` (no Replit connector proxy).
Do NOT use the Replit integrations connector for Stripe on this project — use the secrets tab.
After setting secrets, run the seed script: `pnpm --filter @workspace/scripts run seed-products`

## Hard Rules

- Do NOT redesign the brand, disable RLS, expose secrets, or touch production Vercel
- No emojis in production UI, docs, or status reports (see NO_EMOJI_SWEEP_REPORT.md)
- Image assets: always use `./assets/filename.ext` (relative path), never `/assets/filename.ext`
- Coach email gate: `jeshua@levioperations.com` — hardcoded in RLS policies and JS
