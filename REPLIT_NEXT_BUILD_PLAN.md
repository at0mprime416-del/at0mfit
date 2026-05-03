# REPLIT NEXT BUILD PLAN

> **Prerequisites before any build work**: Re-import from the correct branch (`master`).
> Do not build against the current state — the multi-route app is missing.

---

## Top 10 Next Build Tasks (Priority Order)

### 1. Re-import from `master` branch
**Priority**: CRITICAL — blocks everything else
- The current import is the `main` branch (landing page only)
- Re-import the Vercel project selecting the `master` branch
- Verify `REPLIT-HANDOFF.md` is present after import
- Verify all 6 routes exist: `/`, `/blueprint`, `/calculator`, `/training`, `/portal`, `/coach`

### 2. Get all routes running in Replit
**Priority**: HIGH
- Port each Next.js page from `master` to Vite + React routes in the existing `artifacts/at0mfit-web/` artifact
- Set up React Router / wouter routes for: `/blueprint`, `/calculator`, `/training`, `/portal`, `/coach`
- Verify each page renders without errors in the Replit preview

### 3. Wire all required secrets
**Priority**: HIGH
- Set `GMAIL_USER` and `GMAIL_APP_PASSWORD` in Replit Secrets
- Audit each route for any additional env vars it requires (API keys, service role keys, etc.)
- Add all missing secrets before testing authenticated flows

### 4. Test Supabase connection across all routes
**Priority**: HIGH
- Verify `waitlist` table inserts work end-to-end
- Test any portal/coach authenticated queries
- Confirm RLS policies are respected (do NOT disable RLS)

### 5. Set up `/portal` authentication flow
**Priority**: HIGH
- Port Supabase Auth login/signup from Next.js to Vite + React
- Verify session handling works in the Replit environment
- Test protected route guards

### 6. Port `/coach` AI features
**Priority**: MEDIUM
- Identify what API (OpenAI / Anthropic / etc.) powers the coach
- Add any required API key secrets to Replit
- Port server-side AI calls to Express API server (`artifacts/api-server/`)

### 7. Port `/calculator` logic
**Priority**: MEDIUM
- Port calculator page and any supporting utility functions
- Verify all calculations are client-side (no backend needed)
- Test with sample inputs

### 8. Port `/blueprint` and `/training` pages
**Priority**: MEDIUM
- These are likely content/UI pages — port markup and styles
- Verify fonts, colors, and layout match the original exactly

### 9. Set up `/handoff` route and `REPLIT-HANDOFF.md`
**Priority**: LOW
- Verify `REPLIT-HANDOFF.md` is present after re-import
- Add a `/handoff` route that renders the handoff documentation

### 10. Configure deployment and environment for Replit publish
**Priority**: LOW (do after all routes verified)
- Verify production build (`pnpm build`) works cleanly
- Set up production secrets separately
- Confirm Replit publish config is correct before going live

---

## What Should Be Built in Replit

- All frontend pages and routes (Vite + React)
- Email confirmation logic (Express API server)
- Any AI coach API calls that don't have strict server requirements
- Calculator and blueprint logic (client-side)

## What Should Stay on Vercel / Supabase / Gumroad

- **Vercel**: Keep production live there until Replit is fully verified
- **Supabase**: Keep as the database — do NOT migrate data or disable RLS
- **Gumroad**: Any payment/product links — do NOT move

## What NOT to Touch

- Supabase RLS policies — never disable
- Production Vercel deployment — do not touch until Replit is fully verified
- Supabase `service_role` key — do not expose in frontend code
- Any Gumroad product configuration
- Existing `waitlist` table data
