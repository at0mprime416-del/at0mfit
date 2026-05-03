# AT0M FIT — Replit Operating Pack
**Master reference. Read this first.**  
**Issued:** 2026-05-03 | **From:** OpenClaw → Replit

---

## Quick Reference

| Item | Value |
|------|-------|
| Live site | https://at0mfit.com |
| GitHub repo | https://github.com/at0mprime416-del/at0mfit |
| Active branch | `master` |
| Supabase project | kgozddcutazpqmfbzafa.supabase.co |
| Vercel project ID | prj_mwytZpFWdELjcVOceVV0PlJ446jr |
| Coach email | jeshua@levioperations.com |
| Tech stack | Static HTML + Supabase JS SDK |
| Deploy method | `vercel deploy --prod` |
| Build step | None required |

---

## What Replit Owns

- All code editing for at0mfit.com (HTML/JS/CSS)
- Supabase query testing and DB migrations
- Future feature development
- API integration work (Stripe, Resend, webhooks)
- Mobile app work (at0mfit-app/) when needed

## What Replit Does NOT Own

- Supabase infrastructure (stays live, do not recreate)
- Vercel hosting (stays live, deploy via CLI)
- Gumroad checkout (external, no code changes needed)
- OpenClaw personal automations (Ezra, Pulse, Deborah)

---

## File Structure

```
at0mfit/                ← web site (6 HTML pages + assets)
at0mfit-app/            ← Expo mobile app (separate track)
```

### Web Site Pages

| File | Route | Lines | Size |
|------|-------|-------|------|
| index.html | / | 1,207 | 34KB |
| blueprint.html | /blueprint | 1,272 | 41KB |
| calculator.html | /calculator | 1,528 | 53KB |
| training.html | /training | 1,345 | 40KB |
| portal.html | /portal | 1,144 | 36KB |
| coach.html | /coach | 1,521 | 57KB |

Each page is fully self-contained: inline CSS, inline JS, CDN-loaded Supabase SDK and Google Fonts.

---

## Deploy Commands

```bash
# Deploy to production
cd at0mfit
vercel deploy --prod --yes --token $VERCEL_TOKEN

# Push to GitHub (preview deploy only — until Vercel branch config updated)
git add -A && git commit -m "message" && git push origin master
```

---

## Database Summary

37 tables live. RLS enabled on all. Key tables for current feature work:

| Table | Who Uses It |
|-------|------------|
| `clients` | Coach (reads all), client (reads own row) |
| `applications` | Anyone (INSERT), coach (SELECT + UPDATE) |
| `programs` | Coach (INSERT + SELECT) |
| `workouts` | Coach (INSERT), client (reads via assigned_workouts) |
| `assigned_workouts` | Coach (INSERT + SELECT), client (SELECT) |
| `workout_logs` | Client (INSERT + SELECT), coach (SELECT) |
| `checkins` | Client (INSERT + SELECT), coach (SELECT) |
| `messages` | Both (INSERT with sender constraint, SELECT) |
| `coach_notes` | Coach (ALL), client (SELECT if visible) |

Full schema: `sql/01_base_schema.sql`

---

## Active RLS Pattern

**Client access:** `auth.uid() = client_id`  
**Coach access:** `auth.jwt() ->> 'email' = 'jeshua@levioperations.com'`  
**Public access:** `WITH CHECK (true)` — applications table INSERT only

---

## Build Priority Order

1. Coach "Add Note" UI form — `coach_notes` table ready, no UI
2. Portal check-in history display — query exists, display not built
3. Portal workout log history display — same
4. Application form browser test — not tested live end-to-end
5. Stripe integration — deferred until 10+ clients

---

## Hard Rules

```
1. No service role key in any HTML file. Ever.
2. No RLS policy changes without explicit instruction.
3. workouts.user_id = client's auth UUID (not coach's).
4. Restart PostgREST after every ALTER TABLE.
5. No emojis in user-facing text.
6. Brand: #0B0B0B bg, #C9A04A gold, Bebas Neue + Inter fonts.
7. Use 'master' branch. Never touch 'main'.
8. Test in incognito after portal/coach changes.
```

---

## Supporting Documents in This Package

| File | Contents |
|------|----------|
| `CURRENT_STATE.md` | Live status, QA results, what works |
| `DECISIONS_LOG.md` | All key build decisions |
| `BRAND_GUIDE.md` | Full color + typography system |
| `PRODUCT_OFFER_BRIEF.md` | Products, pricing, CTAs |
| `CLIENT_WORKFLOW.md` | 11-step client journey |
| `COACH_WORKFLOW.md` | 9-step coach journey |
| `REMAINING_BUILDOUT_TASKS.md` | Prioritized build backlog |
| `KNOWN_BUGS_AND_RISKS.md` | Bugs, risks, watch-outs |
| `AUTOMATION_MIGRATION_PLAN.md` | Automation kill/keep/build list |
| `OPENCLAW_SHUTDOWN_PLAN.md` | Shutdown sequence |
| `sql/01_base_schema.sql` | All 37 tables |
| `sql/02_rls_policies.sql` | Mobile + portal RLS |
| `sql/03_application_fixes.sql` | Anon INSERT + created_at patches |
| `sql/04_workout_table_fixes.sql` | Coach portal column additions |
| `sql/05_coach_dashboard_rls.sql` | Coach email-gated policies |
| `sql/README_SQL_ORDER.md` | When and how to run SQL |
| `env/.env.example` | All variable names (no values) |
| `docs/ROUTE_MAP.md` | 6 live routes + auth details |
| `docs/API_INTEGRATION_MAP.md` | All integrations |
| `docs/REPLIT_IMPORT_STEPS.md` | Step-by-step Replit setup |
| `docs/FIRST_REPLIT_AGENT_PROMPT.md` | Paste-ready agent prompt |
| `assets/ASSET_MAP.md` | 15 images, sizes, usage |

---

## QCmd Status

**All 15 handoff gates cleared.**

- Source code: GitHub repo confirmed, all pushed
- SQL: 5 blocks covering all 37 tables + RLS + patches
- Env vars: names listed, no values
- Secrets exposed: none
- Routes: 6 confirmed 200 OK
- Build/run commands: documented
- Replit import: 8-step guide
- Product context: complete
- Brand guide: complete
- Portal workflow: 11 steps
- Coach workflow: 9 steps
- Buildout tasks: 10 items prioritized
- Known bugs: documented
- Automation plan: kill list + future automations
- Shutdown plan: clear trigger and sequence

**QCmd: ✅ PASS**
