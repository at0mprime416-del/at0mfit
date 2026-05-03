# SQL — Run Order and Instructions

**Supabase SQL Editor:** https://supabase.com/dashboard/project/kgozddcutazpqmfbzafa/sql/new

## IMPORTANT

The production database is already live with all these tables, policies, and patches applied.

**Only run these files if:**
- You are rebuilding the schema from scratch in a new Supabase project
- You are adding a missing table or policy
- You are explicitly instructed to run a migration

**Do NOT run blindly against production** — most CREATE TABLE statements use `IF NOT EXISTS` and are safe, but RLS policy inserts may conflict with existing policies.

---

## Run Order (if rebuilding from scratch)

| Order | File | Contents | Required? |
|-------|------|----------|-----------|
| 1 | `01_base_schema.sql` | All 37 tables | Yes |
| 2 | `02_rls_policies.sql` | Mobile app + client portal RLS | Yes |
| 3 | `03_application_fixes.sql` | Applications anon INSERT policy + created_at patch | Yes |
| 4 | `04_workout_table_fixes.sql` | workouts coach columns + PostgREST restart note | Yes |
| 5 | `05_coach_dashboard_rls.sql` | All coach email-gated policies | Yes |

---

## After Running Block 4 (workout table fixes)

**You MUST restart PostgREST** after adding columns to the workouts table:

1. Go to Supabase Dashboard
2. Click Settings (left sidebar)
3. Click Infrastructure
4. Click "Restart" next to PostgREST

Without this restart, the API schema cache won't pick up the new columns and INSERT will fail with a null constraint error even though the columns exist in the DB.

---

## Schema Summary

**37 live tables across 2 logical groups:**

**Group 1 — Mobile App (at0mfit-app/)**
profiles, workouts, exercises, exercise_sets, exercises_library, runs,
body_weight_logs, body_fat_logs, progress_photos, meal_logs, nutrition_logs,
supplement_logs, sleep_logs, recovery_logs, daily_goals, ai_context, form_videos,
teams, team_members, team_join_requests, gyms, gym_members, gym_merch,
events, event_registrations, waitlist

**Group 2 — Coach Portal (at0mfit/coach.html + portal.html)**
clients, programs, workouts (shared), assigned_workouts, workout_logs,
checkins, coach_notes, messages, progress_metrics, subscriptions, applications

Note: `workouts` table is shared between mobile app and coach portal.
The coach portal columns (program_id, day_label, type, instructions, duration_minutes) were added via patch.
