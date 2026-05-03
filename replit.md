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
| `/portal` | Static HTML | Client Portal login (Supabase auth — partial) |
| `/coach` | Static HTML | Coach Dashboard login (Supabase auth — partial) |

## Static HTML Routing

Static pages live in `artifacts/at0mfit-web/public/`.
A Vite middleware plugin (`staticHtmlRewritePlugin`) in `vite.config.ts` rewrites
clean paths → `.html` files. All 15 image assets are also in `public/`.

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
| `VITE_SUPABASE_URL` | Frontend | ✅ Set |
| `VITE_SUPABASE_ANON_KEY` | Frontend | ✅ Set |
| `GMAIL_USER` | API server | ⚠️ Not set |
| `GMAIL_APP_PASSWORD` | API server | ⚠️ Not set |

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

Do NOT redesign the brand, disable RLS, expose secrets, or touch production Vercel.
