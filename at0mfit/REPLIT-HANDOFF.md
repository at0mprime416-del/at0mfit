# AT0M FIT — Replit Migration Handoff
**Prepared:** 2026-05-03  
**Status:** Export ready. All live routes confirmed 200 OK.

---

## What This Is

A complete context transfer so Replit can take over as the build environment for AT0M FIT.

**Replit takes over:**
- Backend buildout (new features, bug fixes)
- Coach dashboard & portal improvements
- Automation scripts
- API integrations
- Future feature development

**Not being replaced:**
- Supabase (database + auth) — stays live at kgozddcutazpqmfbzafa
- Vercel (production hosting) — stays live at at0mfit.vercel.app / at0mfit.com
- Live routes (all confirmed working — see below)

---

## Live Production URLs

| Route | URL | Status |
|-------|-----|--------|
| / (homepage) | https://at0mfit.com | ✅ 200 |
| /blueprint | https://at0mfit.com/blueprint | ✅ 200 |
| /calculator | https://at0mfit.com/calculator | ✅ 200 |
| /training | https://at0mfit.com/training | ✅ 200 |
| /portal | https://at0mfit.com/portal | ✅ 200 |
| /coach | https://at0mfit.com/coach | ✅ 200 |

---

## Repository

- **Vercel Project:** `prj_mwytZpFWdELjcVOceVV0PlJ446jr`
- **GitHub Repo:** `at0mprime416-del/at0mfit`
- **Deploy:** push to main → Vercel auto-deploys

---

## Project Structure

```
at0mfit/                        ← PRODUCTION: static web site + coach portal
├── index.html                  ← Homepage (hero, CTA, features, waitlist)
├── blueprint.html              ← Cardio Blueprint page (1,272 lines)
├── calculator.html             ← HR Zone Calculator (1,528 lines)
├── training.html               ← Custom Training offer page (1,345 lines)
├── portal.html                 ← Client Portal (auth required) (1,144 lines)
├── coach.html                  ← Coach Dashboard (auth + email gate) (1,521 lines)
├── package.json                ← Static site config (no build step needed)
├── vercel.json                 ← Route mappings
└── *.png / *.jpg               ← Brand assets (11MB total)

at0mfit-app/                    ← MOBILE: Expo / React Native app
├── App.js                      ← Root component (notifications, nav, profile)
├── app.json                    ← Expo config (bundle IDs, permissions)
├── babel.config.js             ← babel-preset-expo + reanimated plugin
├── eas.json                    ← EAS build config (internal APK preview)
├── package.json                ← All dependencies (see below)
├── package-lock.json           ← Lock file
├── supabase-schema.sql         ← Original schema (v1 — see Live Schema below)
├── supabase-runs-migration.sql ← Runs table migration
├── .env                        ← Secret variables (DO NOT COMMIT — see Env Vars)
├── src/
│   ├── navigation/index.js     ← Root + Stack + Bottom Tab navigators
│   ├── screens/
│   │   ├── SplashScreen.js
│   │   ├── LoginScreen.js
│   │   ├── SignUpScreen.js
│   │   ├── ForgotPasswordScreen.js
│   │   ├── HomeScreen.js       ← AI Daily Brief (PRO/FREE), streak, team
│   │   ├── WorkoutScreen.js    ← Log workouts, sets, reps, weight
│   │   ├── AIWorkoutScreen.js  ← AI-generated workout (GPT-4o)
│   │   ├── RunScreen.js        ← Manual run log
│   │   ├── LiveRunScreen.js    ← GPS live run tracking
│   │   ├── CalendarScreen.js   ← Training calendar
│   │   ├── ProgressScreen.js   ← Body weight, body fat, photos
│   │   ├── NutritionScreen.js  ← Meal log, macros, sleep log
│   │   ├── ProfileScreen.js    ← Profile, avatar, filter, settings
│   │   ├── CompeteScreen.js    ← Leaderboard, tokens
│   │   ├── LeaderboardScreen.js
│   │   ├── GymScreen.js        ← Gym discovery + team
│   │   ├── EventsScreen.js     ← Events
│   │   ├── FormCheckScreen.js  ← Form video recording
│   │   └── (LeaderboardScreen.js — not yet wired in nav)
│   ├── components/
│   │   ├── Card.js
│   │   ├── GoldButton.js
│   │   ├── FilteredImage.js    ← Avatar image + filter overlay
│   │   └── PhotoFilterModal.js ← Filter selector UI
│   ├── lib/
│   │   ├── supabase.js         ← Supabase client (anon key, AsyncStorage)
│   │   ├── aiGoals.js          ← GPT-4o daily goals + workout generation
│   │   └── notifications.js    ← Push notifications (Expo)
│   ├── context/
│   │   └── ProfileContext.js   ← Global profile state
│   └── theme/
│       ├── colors.js           ← Brand palette
│       └── fonts.js            ← Typography
```

---

## Web Site: package.json

```json
{
  "name": "at0mfit",
  "version": "1.0.0",
  "description": "AT0M FIT — static site",
  "scripts": {
    "vercel-build": "echo 'static site, no build needed'"
  }
}
```

## Web Site: vercel.json

```json
{
  "version": 2,
  "routes": [
    { "src": "/blueprint",   "dest": "/blueprint.html" },
    { "src": "/calculator",  "dest": "/calculator.html" },
    { "src": "/training",    "dest": "/training.html" },
    { "src": "/portal",      "dest": "/portal.html" },
    { "src": "/coach",       "dest": "/coach.html" },
    { "src": "/(.*)",        "dest": "/$1" }
  ]
}
```

---

## Mobile App: Dependencies

```json
{
  "dependencies": {
    "@react-native-async-storage/async-storage": "1.23.1",
    "@react-native-community/netinfo": "11.3.1",
    "@react-navigation/bottom-tabs": "^6.5.0",
    "@react-navigation/native": "^6.1.0",
    "@react-navigation/stack": "^6.3.0",
    "@supabase/supabase-js": "^2.39.0",
    "expo": "~51.0.0",
    "expo-av": "~14.0.7",
    "expo-background-fetch": "~12.0.1",
    "expo-camera": "~15.0.16",
    "expo-image-picker": "~15.1.0",
    "expo-keep-awake": "~13.0.2",
    "expo-location": "~17.0.1",
    "expo-media-library": "~16.0.5",
    "expo-notifications": "^55.0.12",
    "expo-status-bar": "~1.12.1",
    "expo-task-manager": "~11.8.2",
    "react": "18.2.0",
    "react-native": "0.74.1",
    "react-native-maps": "1.14.0",
    "react-native-reanimated": "~3.10.0",
    "react-native-safe-area-context": "4.10.5",
    "react-native-screens": "3.31.1",
    "react-native-svg": "^15.15.3",
    "react-native-url-polyfill": "^2.0.0"
  },
  "devDependencies": {
    "@babel/core": "^7.20.0"
  },
  "scripts": {
    "start":   "expo start",
    "android": "expo start --android",
    "ios":     "expo start --ios",
    "web":     "expo start --web"
  }
}
```

---

## Environment Variables (Names Only — No Values)

Set these as Replit Secrets:

**Mobile App (.env / Replit Secrets)**
```
EXPO_PUBLIC_SUPABASE_URL
EXPO_PUBLIC_SUPABASE_ANON_KEY
EXPO_PUBLIC_OPENAI_API_KEY
```

**Web Site + Coach Dashboard (inline in HTML — move to env if going server-side)**
```
SUPABASE_URL
SUPABASE_ANON_KEY
```

**Optional / Future Integrations**
```
VERCEL_TOKEN
GOOGLE_MAPS_API_KEY
ELEVENLABS_API_KEY
FAL_AI_API_KEY
RUNWAY_API_KEY
MUBERT_LICENSE_TOKEN
OPENAI_API_KEY
AGENTOPS_API_KEY
```

> ⚠️ The mobile app currently has Supabase anon key hardcoded in src/lib/supabase.js.  
> Recommended: move to EXPO_PUBLIC_ env vars before any public deployment.

---

## Supabase — Live Database

**Project:** kgozddcutazpqmfbzafa.supabase.co  
**Auth:** Email/password, RLS enabled on all tables

### Live Schema (as of 2026-05-02)

37 tables in production:

| Table | Purpose |
|-------|---------|
| `profiles` | User profile (weight, goal, tier, avatar, tokens) |
| `workouts` | Workout sessions (user_id, name, date, program_id, day_label, type, instructions, duration_minutes) |
| `exercises` | Exercises within workouts |
| `exercise_sets` | Sets per exercise (weight, reps, completed) |
| `exercises_library` | Global exercise reference |
| `runs` | Run logs (distance, pace, HR, cadence, elevation) |
| `body_weight_logs` | Daily weight tracking |
| `body_fat_logs` | Body fat % tracking |
| `progress_photos` | Progress photo URLs + filters |
| `meal_logs` | Meal + macro tracking |
| `nutrition_logs` | Daily eating window, carb day type |
| `supplement_logs` | Supplement stack tracking |
| `sleep_logs` | Sleep hours + quality |
| `recovery_logs` | Sleep, soreness, mobility, cold therapy |
| `daily_goals` | AI-generated daily goals |
| `ai_context` | Weekly AI summaries (memory layer) |
| `form_videos` | Form check video URLs |
| `teams` | Fitness teams |
| `team_members` | Team membership + tokens |
| `team_join_requests` | Join request flow |
| `gyms` | Gym profiles |
| `gym_members` | Gym membership |
| `gym_merch` | Gym merch listings |
| `events` | Fitness events |
| `event_registrations` | Event signups + results |
| `leaderboard` | View: id, name, tier, tokens, team |
| `clients` | Coach-managed clients |
| `programs` | Training programs per client |
| `assigned_workouts` | Coach → client workout assignments |
| `workout_logs` | Client workout completion logs (RPE, duration) |
| `checkins` | Weekly client check-ins (adherence, sleep, stress, energy) |
| `coach_notes` | Coach notes (visible_to_client flag) |
| `messages` | Coach ↔ client messaging |
| `progress_metrics` | Coach-side client metrics |
| `subscriptions` | Client subscription records |
| `applications` | New client intake applications |
| `waitlist` | Email waitlist |

### RLS Summary
- Users can only access their own data (all tables gated by `auth.uid()`)
- Coach (jeshua@levioperations.com) has additional SELECT/INSERT policies on all client tables via `auth.jwt() ->> 'email' = 'jeshua@levioperations.com'`
- Applications: anon INSERT allowed (intake form), coach-only SELECT
- Leaderboard: public SELECT view

---

## Coach Dashboard — Email Gate

`coach.html` line logic:
```javascript
const COACH_EMAIL = 'jeshua@levioperations.com';
// On login: if user.email !== COACH_EMAIL → signOut() + show restrictedView
```

This gate is client-side only. RLS policies are the real enforcement at the DB layer.

---

## AI / GPT Integration

**File:** `src/lib/aiGoals.js`  
**Model:** gpt-4o  
**Functions:**
- `generateDailyGoal(userId)` — FREE: simple goal. PRO: full brief (workout + nutrition + sleep + supplements)
- `generateAIWorkout(userId)` — Full context workout prescription
- `buildUserContext(userId)` — Assembles 30-day history (weight, nutrition, sleep, supplements, workouts, runs, PRs)
- `getAIContext(userId)` — Returns last 4 weekly summaries + current context
- `saveWeeklySummary(userId)` — Upserts to ai_context table

**Tier logic:** `profiles.subscription_tier = 'pro'` unlocks full AI brief.

---

## Mobile App Navigation Structure

```
RootNavigator (Stack)
├── Splash
├── Login
├── SignUp
├── ForgotPassword
├── Main (Bottom Tab — 5 tabs)
│   ├── Home (HomeScreen)
│   ├── Train (Stack)
│   │   ├── Workout
│   │   ├── Run
│   │   ├── AIWorkout
│   │   └── Progress
│   ├── Compete (Stack)
│   │   ├── Leaderboard
│   │   └── Events
│   ├── Community (Stack)
│   │   ├── Gym
│   │   ├── Calendar
│   │   └── Nutrition
│   └── Profile
├── LiveRun (fullscreen overlay)
└── FormCheck (fullscreen overlay)
```

---

## Build System

**Web site:** No build step. Push HTML + assets → Vercel auto-deploys.  
**Mobile app:** `expo start` for dev. EAS Build for iOS/Android binaries.

```bash
# Web: deploy
git add -A && git commit -m "update" && git push

# Mobile: start dev
cd at0mfit-app && npm install && npm start

# Mobile: build internal APK
eas build --platform android --profile preview
```

---

## What Replit Should Pick Up Next

In priority order:

1. **Coach password** — Set real password at Supabase Dashboard → Authentication → Users (current test pw is temporary)
2. **Harden anon key** — Move SUPABASE_ANON_KEY out of coach.html / portal.html source into Vercel env vars + reference via server-side or build injection
3. **Coach notes UI** — coach.html has no "Add Note" form yet (data model exists, UI not built)
4. **Application accept/reject flow** — Mark Reviewed works, but no "Convert to client" button exists yet
5. **Stripe** — Deferred until 10+ clients. When ready: add `/api/checkout` route + webhook
6. **Portal check-in history** — Portal shows submission form but not past check-in records for client view
7. **Workout log display** — Portal shows assigned workout but no history of past logs

---

## QA Status (2026-05-02)

All 24 QA checks passed:
- /coach loads ✅  
- /portal loads ✅  
- Service key not exposed ✅  
- Coach login (email gate) ✅  
- Non-coach RLS isolation ✅  
- Applications queue ✅  
- Client roster ✅  
- Create program ✅  
- Assign workout (all 5 schema columns) ✅  
- Workout visible in portal ✅  
- Workout log ✅  
- Check-in ✅  
- Messages both directions ✅  
- Coach reads client data ✅

---

## Files NOT Included in Replit Handoff

- `node_modules/` — run `npm install` after clone
- `.env` — set secrets in Replit Secrets panel
- QC reports (QC-REPORT-V1 through V8) — historical build logs, not needed for ongoing work
- `/media/` and ebook files — not part of web/app builds
- `projects/` folder context — AT0M has full context in this document

---

## Replit Setup Steps

1. Import repo from GitHub: `at0mprime416-del/at0mfit`
2. Set Replit Secrets (see Environment Variables section above)
3. For **web site** work: edit HTML files directly, push to trigger Vercel deploy
4. For **mobile app** work: `cd at0mfit-app && npm install && npm start`
5. For **DB changes**: use Supabase dashboard SQL editor at kgozddcutazpqmfbzafa.supabase.co

---

*Prepared by AT0M (OpenClaw) — 2026-05-03*
