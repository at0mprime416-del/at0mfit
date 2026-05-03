-- ============================================================
-- AT0M FIT — Block 3: Application Fixes
-- Covers:
--   1. Anonymous INSERT policy for intake form
--   2. created_at column added to applications table
--   3. created_at column added to checkins table
-- Run after Blocks 1 and 2.
-- ============================================================

-- Fix 1: Allow anonymous users to submit the intake application form
-- (Anyone on the /training page can apply — no login required)
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='applications' AND policyname='Applications insert anon') THEN
    CREATE POLICY "Applications insert anon" ON public.applications
      FOR INSERT WITH CHECK (true);
  END IF;
END $$;

-- Fix 2: applications table — add created_at column
-- The coach.html dashboard sorts applications by created_at.
-- Original schema only had submitted_at.
ALTER TABLE public.applications
  ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT NOW();

-- Backfill existing rows from submitted_at
UPDATE public.applications
  SET created_at = submitted_at
  WHERE created_at IS NULL AND submitted_at IS NOT NULL;

-- Fix 3: checkins table — add created_at column
-- The coach.html dashboard sorts check-ins by created_at.
-- Original schema only had submitted_at.
ALTER TABLE public.checkins
  ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT NOW();

-- Backfill existing rows from submitted_at
UPDATE public.checkins
  SET created_at = submitted_at
  WHERE created_at IS NULL AND submitted_at IS NOT NULL;

-- Verify
SELECT 'applications' AS tbl, column_name FROM information_schema.columns
  WHERE table_name = 'applications' AND column_name IN ('submitted_at','created_at')
UNION ALL
SELECT 'checkins', column_name FROM information_schema.columns
  WHERE table_name = 'checkins' AND column_name IN ('submitted_at','created_at');
