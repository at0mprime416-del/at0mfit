-- ============================================================
-- AT0M FIT — Block 4: Workout Table Fixes
-- Adds coach portal columns to the workouts table.
-- These columns enable coach dashboard workout assignment.
--
-- CRITICAL: After running this block, you MUST restart PostgREST:
--   Supabase Dashboard → Settings → Infrastructure → Restart PostgREST
--
-- Without the restart, the API schema cache will not include the new
-- columns. INSERT will fail with a null constraint error even though
-- the columns exist in the DB. This is a known Supabase limitation.
-- pg_notify('pgrst','reload schema') does NOT work on hosted Supabase.
-- ============================================================

-- Add coach portal columns to workouts table
ALTER TABLE public.workouts ADD COLUMN IF NOT EXISTS program_id UUID;
ALTER TABLE public.workouts ADD COLUMN IF NOT EXISTS day_label TEXT;
ALTER TABLE public.workouts ADD COLUMN IF NOT EXISTS type TEXT;
ALTER TABLE public.workouts ADD COLUMN IF NOT EXISTS instructions TEXT;
ALTER TABLE public.workouts ADD COLUMN IF NOT EXISTS duration_minutes INTEGER;

-- Note: program_id does NOT have a FK to programs in the live DB.
-- The original portal schema had workouts without user_id and without program_id FK.
-- The mobile app schema had workouts with user_id but without coach columns.
-- The live DB resolved this by merging both: user_id (required) + program_id (nullable, no FK).
-- This is intentional — avoids cascade issues and works for both mobile and portal use cases.

-- Verify columns exist
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'workouts'
ORDER BY ordinal_position;

-- ── AFTER RUNNING THIS BLOCK ──────────────────────────────────────────────────
-- Go to Supabase Dashboard → Settings → Infrastructure → click Restart PostgREST
-- Wait ~10 seconds, then test an INSERT to verify columns are visible.
--
-- Test INSERT (adjust UUIDs to real values):
-- INSERT INTO public.workouts (user_id, name, day_label, type, instructions, duration_minutes, date)
-- VALUES ('[client-uuid]', 'Test Workout', 'Monday', 'zone2', 'Run at 130-145 bpm', 45, CURRENT_DATE)
-- RETURNING id, name, day_label, type, duration_minutes;
