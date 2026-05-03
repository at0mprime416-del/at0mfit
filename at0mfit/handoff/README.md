# AT0M FIT — Replit Handoff Package
**Prepared:** 2026-05-03  
**From:** OpenClaw (AT0M)  
**To:** Replit Agent

---

## What This Is

A complete context transfer for Replit to take over the AT0M FIT buildout. Every file in this package was generated from production state — not from drafts or templates.

**Live site:** https://at0mfit.com  
**GitHub repo:** https://github.com/at0mprime416-del/at0mfit (branch: `master`)  
**Supabase project:** kgozddcutazpqmfbzafa.supabase.co  
**Vercel project:** prj_mwytZpFWdELjcVOceVV0PlJ446jr

---

## Package Contents

```
at0mfit-replit-handoff/
├── README.md                         ← This file
├── REPLIT_OPERATING_PACK.md          ← Full master reference (read first)
├── CURRENT_STATE.md                  ← Live status: what works, what's broken
├── DECISIONS_LOG.md                  ← All key decisions made during build
├── BRAND_GUIDE.md                    ← Colors, typography, visual rules
├── PRODUCT_OFFER_BRIEF.md            ← Product ladder, pricing, positioning
├── CLIENT_WORKFLOW.md                ← End-to-end client journey
├── COACH_WORKFLOW.md                 ← Coach/admin journey
├── REMAINING_BUILDOUT_TASKS.md       ← Prioritized build backlog
├── KNOWN_BUGS_AND_RISKS.md           ← Bugs, untested flows, risks
├── AUTOMATION_MIGRATION_PLAN.md      ← What to kill, keep, build
├── OPENCLAW_SHUTDOWN_PLAN.md         ← Shutdown sequence
│
├── sql/
│   ├── README_SQL_ORDER.md           ← Run order and instructions
│   ├── 01_base_schema.sql            ← All 37 tables
│   ├── 02_rls_policies.sql           ← Client + mobile RLS
│   ├── 03_application_fixes.sql      ← Anon INSERT fix + created_at patch
│   ├── 04_workout_table_fixes.sql    ← Coach portal columns patch
│   └── 05_coach_dashboard_rls.sql    ← Coach email-gated policies
│
├── env/
│   └── .env.example                  ← Variable names only (no values)
│
├── docs/
│   ├── ROUTE_MAP.md                  ← All 6 live routes
│   ├── API_INTEGRATION_MAP.md        ← All third-party integrations
│   ├── REPLIT_IMPORT_STEPS.md        ← Step-by-step Replit setup
│   └── FIRST_REPLIT_AGENT_PROMPT.md  ← Paste-ready prompt for Replit Agent
│
└── assets/
    └── ASSET_MAP.md                  ← All images, sizes, locations, usage
```

---

## Start Here

1. Read `REPLIT_OPERATING_PACK.md` — master reference
2. Read `CURRENT_STATE.md` — know what's working right now
3. Follow `docs/REPLIT_IMPORT_STEPS.md` — get Replit connected
4. Use `docs/FIRST_REPLIT_AGENT_PROMPT.md` — give Replit Agent its first brief
5. Run SQL files only if rebuilding from scratch (production DB is already live)

---

## Source Code

**GitHub repo is ready for Replit import:**
- URL: `https://github.com/at0mprime416-del/at0mfit`
- Branch: `master`
- Status: All changes committed and pushed as of 2026-05-03
- Framework: None (static HTML — no build step required)

Do not use the `main` branch — it contains an old Next.js prototype that is no longer in production.

---

## QCmd Status

All gates passed. No secret values are included in this package. Variable names only.
