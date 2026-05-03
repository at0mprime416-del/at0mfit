-- ============================================================
-- AT0M FIT — Block 2: RLS Policies (Mobile App + Client Portal)
-- Run after Block 1.
-- Safe: wrapped in DO $$ BEGIN IF NOT EXISTS checks.
-- ============================================================

-- ── ENABLE RLS ON ALL TABLES ──────────────────────────────────────────────────

ALTER TABLE public.profiles             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workouts             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercises            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercise_sets        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.runs                 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.body_weight_logs     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.body_fat_logs        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meal_logs            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.supplement_logs      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sleep_logs           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recovery_logs        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_goals          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.nutrition_logs       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.clients              ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.programs             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.assigned_workouts    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_logs         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.checkins             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.coach_notes          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.progress_metrics     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriptions        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.applications         ENABLE ROW LEVEL SECURITY;

-- ── MOBILE APP: USER-OWNS-THEIR-DATA POLICIES ────────────────────────────────

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='profiles' AND policyname='profiles_select_own') THEN
    CREATE POLICY "profiles_select_own" ON public.profiles FOR SELECT USING (auth.uid() = id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='profiles' AND policyname='profiles_insert_own') THEN
    CREATE POLICY "profiles_insert_own" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='profiles' AND policyname='profiles_update_own') THEN
    CREATE POLICY "profiles_update_own" ON public.profiles FOR UPDATE USING (auth.uid() = id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='workouts' AND policyname='workouts_select_own') THEN
    CREATE POLICY "workouts_select_own" ON public.workouts FOR SELECT USING (auth.uid() = user_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='workouts' AND policyname='workouts_insert_own') THEN
    CREATE POLICY "workouts_insert_own" ON public.workouts FOR INSERT WITH CHECK (auth.uid() = user_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='workouts' AND policyname='workouts_update_own') THEN
    CREATE POLICY "workouts_update_own" ON public.workouts FOR UPDATE USING (auth.uid() = user_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='workouts' AND policyname='workouts_delete_own') THEN
    CREATE POLICY "workouts_delete_own" ON public.workouts FOR DELETE USING (auth.uid() = user_id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='runs' AND policyname='runs_select_own') THEN
    CREATE POLICY "runs_select_own" ON public.runs FOR SELECT USING (auth.uid() = user_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='runs' AND policyname='runs_insert_own') THEN
    CREATE POLICY "runs_insert_own" ON public.runs FOR INSERT WITH CHECK (auth.uid() = user_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='runs' AND policyname='runs_update_own') THEN
    CREATE POLICY "runs_update_own" ON public.runs FOR UPDATE USING (auth.uid() = user_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='runs' AND policyname='runs_delete_own') THEN
    CREATE POLICY "runs_delete_own" ON public.runs FOR DELETE USING (auth.uid() = user_id);
  END IF;
END $$;

-- ── CLIENT PORTAL: CLIENT-OWNS-THEIR-DATA POLICIES ───────────────────────────

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='clients' AND policyname='Clients view own data') THEN
    CREATE POLICY "Clients view own data" ON public.clients
      FOR SELECT USING (auth.uid() = id);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='assigned_workouts' AND policyname='Clients view own workouts') THEN
    CREATE POLICY "Clients view own workouts" ON public.assigned_workouts
      FOR SELECT USING (auth.uid() = client_id);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='workout_logs' AND policyname='Clients insert own logs') THEN
    CREATE POLICY "Clients insert own logs" ON public.workout_logs
      FOR INSERT WITH CHECK (auth.uid() = client_id);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='workout_logs' AND policyname='Clients view own logs') THEN
    CREATE POLICY "Clients view own logs" ON public.workout_logs
      FOR SELECT USING (auth.uid() = client_id);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='checkins' AND policyname='Clients submit checkins') THEN
    CREATE POLICY "Clients submit checkins" ON public.checkins
      FOR INSERT WITH CHECK (auth.uid() = client_id);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='checkins' AND policyname='Clients view own checkins') THEN
    CREATE POLICY "Clients view own checkins" ON public.checkins
      FOR SELECT USING (auth.uid() = client_id);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='coach_notes' AND policyname='Clients view coach notes') THEN
    CREATE POLICY "Clients view coach notes" ON public.coach_notes
      FOR SELECT USING (auth.uid() = client_id AND is_visible_to_client = true);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='messages' AND policyname='Clients view messages') THEN
    CREATE POLICY "Clients view messages" ON public.messages
      FOR SELECT USING (auth.uid() = client_id);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='messages' AND policyname='Clients send messages') THEN
    CREATE POLICY "Clients send messages" ON public.messages
      FOR INSERT WITH CHECK (auth.uid() = client_id AND sender = 'client');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='progress_metrics' AND policyname='Clients view metrics') THEN
    CREATE POLICY "Clients view metrics" ON public.progress_metrics
      FOR SELECT USING (auth.uid() = client_id);
  END IF;
END $$;
