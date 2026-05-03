# AT0M FIT — FEATURE EXPANSION STATUS

**Date:** 2026-05-03
**Expansion:** Progress Photos, Nutrition Plan, Weekly Calendar, Goal Tracker, Coach Email Notifications

---

## Feature Status

| Feature | Portal | Coach | API | SQL |
|---------|--------|-------|-----|-----|
| Progress Pictures | BUILT — upload form + history, Supabase Storage wired | BUILT — view per client in detail panel | NOTIFY WIRED | NEEDS MIGRATION |
| Nutrition Plan | BUILT — macros display, coach notes, meal timing | BUILT — create/update form per client | — | NEEDS MIGRATION |
| Weekly Calendar | BUILT — 7-day view, filter by workout/nutrition/recovery/all | BUILT — assign items per client + date | — | NEEDS MIGRATION |
| Goal Tracker / Phase Meter | BUILT — phase progress bar, milestones, target date | BUILT — set/update goal + phase % per client | — | NEEDS MIGRATION |
| Coach Email Notifications | Portal fires on all submit events | — | BUILT — POST /api/notify-coach | — |
| Tab Navigation (Portal) | BUILT — Today, Workouts, Nutrition, Calendar, Goals, Photos, Messages, Check-In | — | — | — |

---

## Portal Tabs

| Tab | Contents |
|-----|----------|
| Today | Assigned workout, active goal snapshot, progress metrics, coach notes |
| Workouts | Full assigned workout + Log Completed Workout form |
| Nutrition | Active nutrition plan — calories, protein, carbs, fats, water, meal notes |
| Calendar | 7-day weekly view with filter (All / Workouts / Nutrition / Recovery) |
| Goals | Phase tracker with progress bar, target date, next milestone, coach note |
| Photos | Upload front/side/back + photo history grid |
| Messages | Full thread + send (fires coach notification) |
| Check-In | 4 ratings + notes (fires coach notification) |

---

## Coach Dashboard New Sections (per client)

| Section | Status |
|---------|--------|
| Nutrition Plan — create/update | BUILT — in client detail panel |
| Goal Tracker — set/update phase | BUILT — in client detail panel |
| Progress Photos — view per client | BUILT — in client detail panel |
| Weekly Calendar — assign items | BUILT — in client detail panel |

---

## API Routes

| Route | Status |
|-------|--------|
| POST /api/notify-coach | BUILT — sends branded coach email |
| POST /api/waitlist-confirm | EXISTING |
| GET /api/healthz | EXISTING |

---

## Email Notifications

| Trigger | Status |
|---------|--------|
| Client submits check-in | WIRED — fires POST /api/notify-coach |
| Client logs workout | WIRED — fires POST /api/notify-coach |
| Client sends message | WIRED — fires POST /api/notify-coach |
| Client uploads progress photo | WIRED — fires POST /api/notify-coach |
| Training application submitted | NOT YET WIRED (add to training.html) |
| Waitlist submitted | NOT YET WIRED (add to home.tsx) |
| Gmail secrets missing | HANDLED — logs skip, returns 200, never crashes |

---

## Owner Actions Required

### 1. Run AT0M_FIT_FEATURE_EXPANSION.sql in Supabase SQL Editor
Creates 4 new tables:
- `progress_photos`
- `nutrition_plans`
- `weekly_plan_items`
- `client_goals`

Each table has RLS enabled with client + coach policies.

### 2. Create `progress-photos` storage bucket in Supabase Dashboard
```
Storage → New Bucket
Name: progress-photos
Public: NO (private)
```
Then add storage policies as documented in AT0M_FIT_FEATURE_EXPANSION.sql.

### 3. Set secrets in Replit
| Secret | Purpose |
|--------|---------|
| `GMAIL_USER` | Coach email sender |
| `GMAIL_APP_PASSWORD` | Gmail App Password |
| `NOTIFICATION_TO_EMAIL` | Optional — defaults to jeshua@levioperations.com |

### 4. Restart API server workflow after adding Gmail secrets

---

## SQL Tables Status

| Table | Status |
|-------|--------|
| clients | EXISTING |
| programs | EXISTING |
| workouts | EXISTING |
| assigned_workouts | EXISTING |
| workout_logs | EXISTING |
| checkins | EXISTING |
| messages | EXISTING |
| progress_metrics | EXISTING |
| applications | EXISTING |
| coach_notes | EXISTING |
| subscriptions | EXISTING |
| **progress_photos** | NEW — run AT0M_FIT_FEATURE_EXPANSION.sql |
| **nutrition_plans** | NEW — run AT0M_FIT_FEATURE_EXPANSION.sql |
| **weekly_plan_items** | NEW — run AT0M_FIT_FEATURE_EXPANSION.sql |
| **client_goals** | NEW — run AT0M_FIT_FEATURE_EXPANSION.sql |

---

## Safety Checks

| Constraint | Status |
|------------|--------|
| Service role key in frontend | NO |
| RLS disabled on new tables | NO — all enabled |
| Vercel touched | NO |
| Brand redesigned | NO |
| Existing routes broken | NO |
| Gmail credentials hardcoded | NO — env vars only |
