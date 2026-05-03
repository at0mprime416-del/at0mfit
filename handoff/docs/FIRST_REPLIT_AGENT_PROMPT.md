# First Replit Agent Prompt

Copy the text below exactly as written and paste it as your first message to the Replit Agent.

---

```
You are taking over as the primary build environment for AT0M FIT — a tactical fitness coaching brand at at0mfit.com.

Read these files immediately before doing anything:

1. README.md — package overview
2. CURRENT_STATE.md — what's live, what's broken, QA results
3. REMAINING_BUILDOUT_TASKS.md — priority build backlog
4. KNOWN_BUGS_AND_RISKS.md — current bugs and risks
5. docs/ROUTE_MAP.md — all 6 live routes
6. BRAND_GUIDE.md — colors, fonts, visual rules (follow strictly)

---

ARCHITECTURE IN ONE SENTENCE:
Static HTML files in at0mfit/ served via Vercel + Supabase JS SDK for auth and database. No server. No build step. No framework.

YOUR WORKING DIRECTORY: at0mfit/
FILES: index.html, blueprint.html, calculator.html, training.html, portal.html, coach.html + image assets

DEPLOY COMMAND: vercel deploy --prod --yes --token $VERCEL_TOKEN
GITHUB: at0mprime416-del/at0mfit, branch: master

---

SUPABASE (DO NOT RECREATE):
Project: kgozddcutazpqmfbzafa.supabase.co
37 live tables, RLS enabled, production data present
SQL schema in sql/ folder (reference only — DB is already live)

COACH DASHBOARD: at0mfit.com/coach
- Email: jeshua@levioperations.com
- Gate: client-side email check + Supabase RLS policies
- All coach RLS policies use: auth.jwt() ->> 'email' = 'jeshua@levioperations.com'

CLIENT PORTAL: at0mfit.com/portal
- Any valid Supabase auth user (client-role)
- Data scoped by RLS per client

---

HARD RULES — NEVER BREAK THESE:

1. Never put the Supabase SERVICE ROLE KEY in any HTML file. The anon key is fine. Service role is not.

2. Never modify Supabase RLS policies without explicit instruction.

3. workouts.user_id must be the CLIENT's auth UUID, not the coach's. If this is wrong, clients cannot see their assigned workouts.

4. After any ALTER TABLE in Supabase: restart PostgREST (Supabase Dashboard → Settings → Infrastructure → Restart PostgREST). Without this, new columns won't be visible via API.

5. Never use emoji in any user-facing text (buttons, headings, body copy, nav).

6. Brand colors: background #0B0B0B, gold #C9A04A, text #F0EDE8, surface #111111. Do not deviate.

7. Fonts: Bebas Neue (headings/display) + Inter (body/UI). Loaded via Google Fonts CDN. Do not add other fonts.

8. Do not merge or deploy from the 'main' GitHub branch. That is an old Next.js prototype. Use 'master' only.

9. Test in an incognito window after any portal/coach changes. Session caching masks bugs.

10. Check browser console for Supabase errors. RLS violations return empty arrays, not thrown errors.

---

BRAND SUMMARY:
Dark (#0B0B0B), Gold (#C9A04A), Warm White (#F0EDE8)
Bebas Neue for headings, Inter for everything else
No emojis. No rounded corners >4px. No gradients. No generic AI imagery.
Tone: premium, tactical, masculine, clean. Direct language. No exclamation points.

---

CURRENT TOP PRIORITIES (from REMAINING_BUILDOUT_TASKS.md):
1. Coach "Add Note" form (coach_notes table exists, no UI yet)
2. Portal check-in history view (submit works, display not built)
3. Portal workout log history (same)
4. Application form end-to-end browser test

ASK BEFORE:
- Running any SQL migration
- Changing RLS policies
- Adding a new third-party integration
- Touching the applications or checkins table structure
- Making changes to /coach or /portal auth flows

FIRST TASK: [Jeshua will give you the first task here]
```

---

## Notes on Using This Prompt

- Paste this exactly as-is into the Replit Agent chat at the start of a new session
- Replace `[Jeshua will give you the first task here]` with the actual first task
- If starting a new session later: paste this prompt again — the Agent doesn't retain memory between sessions
- Keep this file. It's the fastest way to re-orient a new Replit session.
