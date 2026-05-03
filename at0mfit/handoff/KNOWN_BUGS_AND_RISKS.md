# AT0M FIT — Known Bugs and Risks

---

## Active Bugs

| # | Bug | Severity | Affected File | Notes |
|---|-----|----------|--------------|-------|
| 1 | No "Accept Application" button | High functional | coach.html | Not a code bug — feature not built. Manual workaround: Supabase dashboard |
| 2 | No "Add Note" form for coach | Medium functional | coach.html | DB table exists; UI form not built |
| 3 | Portal shows no check-in history | Medium UX | portal.html | Submit works; historical display not built |
| 4 | Portal shows no workout log history | Medium UX | portal.html | Log submit works; history display not built |
| 5 | dead `calendar_brief` cron | Low operational | crontab | File is in `paused/` but crontab still referenced it. **Fixed 2026-05-03 — removed from crontab** |

---

## Untested Flows

| Flow | Risk Level | Notes |
|------|-----------|-------|
| Application modal form (live browser, real submit) | Medium | Tested via API. Modal JS not tested with real user in browser |
| Homepage waitlist form | Medium | Exists in index.html; not tested end-to-end |
| Password reset email | Unknown | Supabase recovery email — SMTP config may need verification |
| Gumroad → PDF delivery email | Low | External system — Gumroad handles; not our code |
| New client signup via Supabase auth | N/A | Signups are disabled intentionally. New clients created manually |
| Mobile app push notifications | Medium | Expo notifications configured; not verified on real device post-schema changes |

---

## Security Risks

| Risk | Severity | Status |
|------|----------|--------|
| Service role key exposed in frontend | None | Confirmed clean in all HTML files ✅ |
| Supabase anon key in HTML source | Accepted | By design — anon key is public, RLS enforces all access |
| Coach email gate is client-side JS | Accepted | RLS is the real enforcement. Client-side gate is UX only |
| Coach account created via DB workaround | Low | Account works but was not created through GoTrue auth flow. **Reset password via Supabase Dashboard immediately** |
| Single coach email hardcoded in 12 RLS policies | Future risk | If coach email ever changes, all 12 policies + coach.html gate must be updated manually |
| No rate limiting on application form | Low | Anonymous INSERT to applications table is unlimited. Not a real concern at current scale |

---

## Deployment Risks

| Risk | Mitigation |
|------|------------|
| GitHub push does NOT auto-deploy production | Use `vercel deploy --prod` manually, OR update Vercel production branch to `master` in Vercel Dashboard |
| PostgREST schema cache stale after ALTER TABLE | Always restart PostgREST in Supabase Dashboard → Settings → Infrastructure after any `ALTER TABLE` command |
| Old `main` branch in GitHub | Contains Next.js prototype. Do not merge or deploy. Ignore entirely. |
| coach.html and portal.html embed Supabase anon key | Acceptable. If key ever needs rotation, update both files |

---

## Previously Fixed Issues (For Reference)

| Issue | Fixed | How |
|-------|-------|-----|
| Applications anon INSERT failed (RLS syntax error) | 2026-05-01 | Rewrote policy: `WITH CHECK (true)`, dropped conflicting old policy |
| workouts INSERT failed (23502 null column error) | 2026-05-01 | Hard PostgREST restart via Supabase Dashboard — schema cache was stale after DROP/RECREATE |
| checkins ORDER BY created_at failed | 2026-05-02 | Added `created_at` column to checkins table (was submitted_at only) |
| applications ORDER BY created_at failed | 2026-05-02 | Added `created_at` column to applications table |
| Portal checkins display broken (null submitted_at) | 2026-05-01 | Changed select to `submitted_at, week_of`, fallback: `raw = ciData[0].submitted_at \|\| ciData[0].week_of` |
| Session restoration using deprecated checkSession() | 2026-05-01 | Replaced with `getSession()` (supabase-js v2) |
| Coach login "Database error querying schema" | 2026-05-02 | Coach account had malformed auth.users + auth.identities records. Rebuilt by swapping working test account to coach email |

---

## What Replit Should Watch Out For

1. **Always restart PostgREST** after any `ALTER TABLE`. Without this, new columns won't be visible to the API even though they exist in the DB.

2. **Test in an incognito window** after any portal/coach changes. Session caching can mask problems.

3. **Never put the service role key in any HTML file.** The anon key is fine. The service role key is not.

4. **Check browser console** for Supabase errors. Most RLS violations appear as empty response arrays rather than thrown errors.

5. **The `workouts.user_id` must be the CLIENT's auth UUID**, not the coach's UUID. Coach inserts the workout on behalf of the client. If this UUID is wrong, the client won't see their workout in the portal.
