# REPLIT TAKEOVER STATUS

## ⛔ CRITICAL: WRONG BRANCH / INCOMPLETE IMPORT

The Vercel import brought in the wrong branch or an incomplete state of the project.
**Stop all build work until the correct source is re-imported.**

---

## Branch Confirmed

- **Current branch**: `main`
- **Expected branch**: `master`
- **Status**: MISMATCH — `master` branch was NOT imported

## Routes Tested

| Route | Status | Notes |
|-------|--------|-------|
| `/` | PASS | Landing page / waitlist page is running |
| `/blueprint` | FAIL | Route does not exist — page not imported |
| `/calculator` | FAIL | Route does not exist — page not imported |
| `/training` | FAIL | Route does not exist — page not imported |
| `/portal` | FAIL | Route does not exist — page not imported |
| `/coach` | FAIL | Route does not exist — page not imported |
| `/handoff` | FAIL | Route does not exist — page not imported |

## Handoff Docs Found

- `REPLIT-HANDOFF.md`: **NOT FOUND**
- `REPLIT_TAKEOVER_STATUS.md`: Created now (this file)
- `REPLIT_NEXT_BUILD_PLAN.md`: Created now
- `REPLIT_RUNBOOK.md`: Created now
- `.env.example`: Created now

## What Was Actually Imported

The imported project (`main` branch) is a **single-page marketing landing page** only:

```
src/app/page.tsx           — landing page with waitlist signup form
src/app/layout.tsx         — root layout (Bebas Neue + Inter fonts)
src/app/globals.css        — dark theme CSS
src/app/api/waitlist-confirm/route.ts  — email confirmation via nodemailer
src/lib/supabase.ts        — Supabase client (waitlist table only)
```

This has been ported to Vite + React at `artifacts/at0mfit-web/` and is running at `/`.

## What Is Missing (Not Imported)

The following features exist on the `master` branch on Vercel/GitHub but were **not imported**:

- `/blueprint` page
- `/calculator` page
- `/training` page
- `/portal` page
- `/coach` page
- `/handoff` page
- `REPLIT-HANDOFF.md`
- Any multi-route app shell or navigation between these pages
- Any portal/coach authentication flows
- Any calculator or blueprint logic

## Supabase Status

- `VITE_SUPABASE_URL`: **Configured** (secret set)
- `VITE_SUPABASE_ANON_KEY`: **Configured** (secret set)
- Waitlist insert to `waitlist` table: **Should be working** (not tested with real submit due to missing secrets at first, now set)
- Portal/coach/authenticated routes: **Cannot test — pages not imported**

## Missing Secrets (For Full App)

The following secrets will be needed once the correct branch is imported:

- `GMAIL_USER` — for waitlist confirmation emails
- `GMAIL_APP_PASSWORD` — for waitlist confirmation emails
- Any additional Supabase service role key if portal uses server-side auth
- Any API keys used by /coach, /calculator, /blueprint features

## Files Changed (During This Session)

| File | Change | Reason |
|------|--------|--------|
| `artifacts/at0mfit-web/src/pages/home.tsx` | Created | Port of landing page from Next.js |
| `artifacts/at0mfit-web/src/App.tsx` | Updated | Added home route |
| `artifacts/at0mfit-web/src/lib/supabase.ts` | Created | Vite env var port |
| `artifacts/at0mfit-web/src/index.css` | Updated | Migrated original styles, removed placeholder tokens |
| `artifacts/at0mfit-web/index.html` | Updated | Added fonts + full SEO meta tags |
| `artifacts/api-server/src/routes/waitlist-confirm.ts` | Created | Port of Next.js API route |
| `artifacts/api-server/src/routes/index.ts` | Updated | Mounted waitlist-confirm route |

## What Works

- Landing page at `/` renders correctly (dark theme, Bebas Neue font, gold accents)
- Waitlist form UI is complete and functional
- Supabase client initialized with env vars
- Email confirmation endpoint wired up (requires `GMAIL_USER` + `GMAIL_APP_PASSWORD` secrets)
- Vite dev server running on correct port

## What Fails / Is Missing

- All routes beyond `/` — not imported (wrong branch)
- `REPLIT-HANDOFF.md` — not found in imported source
- `GMAIL_USER` / `GMAIL_APP_PASSWORD` — not yet set as secrets
- Portal authentication flows — not imported
- Coach AI features — not imported
- Blueprint / calculator logic — not imported

## Production Vercel

- **NOT touched.** Production remains on Vercel, unchanged.

---

## Owner Action Required (Blockers)

1. **Re-import from the correct branch (`master`)** — the current import is the `main` branch landing page only. The full app with `/portal`, `/coach`, `/blueprint`, `/calculator`, `/training`, `/handoff` is on `master`.
2. **Set `GMAIL_USER` and `GMAIL_APP_PASSWORD`** in Replit Secrets for email confirmation to work.
3. **Confirm the correct GitHub repo + branch** before re-importing.
