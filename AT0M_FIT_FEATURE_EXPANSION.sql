-- ═══════════════════════════════════════════════════════════════════════
-- AT0M FIT — FEATURE EXPANSION SQL
-- Run this once in Supabase SQL editor.
-- Safe to run: does not drop or alter existing tables.
-- ═══════════════════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────
-- TABLE 1: progress_photos
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.progress_photos (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id    uuid NOT NULL REFERENCES public.clients(id) ON DELETE CASCADE,
  photo_url    text NOT NULL,
  photo_type   text CHECK (photo_type IN ('front','side','back','other')) DEFAULT 'other',
  notes        text,
  taken_at     date NOT NULL DEFAULT CURRENT_DATE,
  created_at   timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.progress_photos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Client manages own progress photos"
  ON public.progress_photos
  FOR ALL
  USING (auth.uid() = client_id)
  WITH CHECK (auth.uid() = client_id);

CREATE POLICY "Coach reads all progress photos"
  ON public.progress_photos
  FOR SELECT
  USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

CREATE POLICY "Coach manages all progress photos"
  ON public.progress_photos
  FOR ALL
  USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ─────────────────────────────────────────────
-- TABLE 2: nutrition_plans
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.nutrition_plans (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id    uuid NOT NULL REFERENCES public.clients(id) ON DELETE CASCADE,
  title        text NOT NULL,
  calories     integer,
  protein_g    integer,
  carbs_g      integer,
  fats_g       integer,
  water_oz     integer,
  meal_notes   text,
  coach_notes  text,
  is_active    boolean NOT NULL DEFAULT true,
  start_date   date,
  end_date     date,
  created_at   timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.nutrition_plans ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Client reads own nutrition plans"
  ON public.nutrition_plans
  FOR SELECT
  USING (auth.uid() = client_id);

CREATE POLICY "Coach manages all nutrition plans"
  ON public.nutrition_plans
  FOR ALL
  USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ─────────────────────────────────────────────
-- TABLE 3: weekly_plan_items
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.weekly_plan_items (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id           uuid NOT NULL REFERENCES public.clients(id) ON DELETE CASCADE,
  item_date           date NOT NULL,
  item_type           text CHECK (item_type IN ('workout','nutrition','recovery')) NOT NULL,
  title               text NOT NULL,
  description         text,
  related_workout_id  uuid REFERENCES public.workouts(id) ON DELETE SET NULL,
  completed           boolean NOT NULL DEFAULT false,
  created_at          timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.weekly_plan_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Client reads own weekly plan"
  ON public.weekly_plan_items
  FOR SELECT
  USING (auth.uid() = client_id);

CREATE POLICY "Client updates own completed status"
  ON public.weekly_plan_items
  FOR UPDATE
  USING (auth.uid() = client_id)
  WITH CHECK (auth.uid() = client_id);

CREATE POLICY "Coach manages all weekly plan items"
  ON public.weekly_plan_items
  FOR ALL
  USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ─────────────────────────────────────────────
-- TABLE 4: client_goals
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.client_goals (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id        uuid NOT NULL REFERENCES public.clients(id) ON DELETE CASCADE,
  goal_title       text NOT NULL,
  goal_type        text,
  current_phase    text,
  phase_percent    integer CHECK (phase_percent BETWEEN 0 AND 100) DEFAULT 0,
  target_date      date,
  next_milestone   text,
  coach_note       text,
  status           text NOT NULL DEFAULT 'active',
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.client_goals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Client reads own goals"
  ON public.client_goals
  FOR SELECT
  USING (auth.uid() = client_id);

CREATE POLICY "Coach manages all goals"
  ON public.client_goals
  FOR ALL
  USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ─────────────────────────────────────────────
-- SUPABASE STORAGE BUCKET NOTE
-- ─────────────────────────────────────────────
-- Create a storage bucket named: progress-photos
-- In Supabase Dashboard → Storage → New Bucket
--   Name: progress-photos
--   Public: NO (private)
-- Then add these policies in Storage → Policies:
--
-- Policy 1: Clients upload their own photos
--   Operation: INSERT
--   Target roles: authenticated
--   USING: (storage.foldername(name))[1] = auth.uid()::text
--
-- Policy 2: Clients read their own photos
--   Operation: SELECT
--   Target roles: authenticated
--   USING: (storage.foldername(name))[1] = auth.uid()::text
--
-- Policy 3: Coach reads all photos
--   Operation: SELECT
--   Target roles: authenticated
--   USING: auth.jwt() ->> 'email' = 'jeshua@levioperations.com'
--
-- Suggested folder structure: progress-photos/{client_id}/{photo_type}_{date}.jpg
-- ─────────────────────────────────────────────

-- ─────────────────────────────────────────────
-- INDEXES
-- ─────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_progress_photos_client ON public.progress_photos(client_id, taken_at DESC);
CREATE INDEX IF NOT EXISTS idx_nutrition_plans_client ON public.nutrition_plans(client_id, is_active DESC);
CREATE INDEX IF NOT EXISTS idx_weekly_plan_items_client ON public.weekly_plan_items(client_id, item_date);
CREATE INDEX IF NOT EXISTS idx_client_goals_client ON public.client_goals(client_id, status);
