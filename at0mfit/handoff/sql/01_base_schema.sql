-- ============================================================
-- AT0M FIT — Block 1: Base Schema
-- Run first. All 37 production tables.
-- Safe to run: all statements use CREATE TABLE IF NOT EXISTS
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ── MOBILE APP TABLES ─────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  name TEXT,
  goal TEXT CHECK (goal IN ('strength','muscle','fat_loss','endurance','performance')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  weight_lbs NUMERIC(5,1),
  height_inches INTEGER,
  age INTEGER,
  preferred_units TEXT DEFAULT 'lbs',
  subscription_tier TEXT DEFAULT 'free',
  wake_time TEXT DEFAULT '06:00',
  sleep_time TEXT DEFAULT '22:00',
  fitness_level TEXT DEFAULT 'beginner',
  body_fat_pct NUMERIC(4,1),
  avatar_url TEXT,
  avatar_filter TEXT DEFAULT 'original',
  total_tokens INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS public.workouts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  -- Coach portal columns (Block 4 patches these in if adding to existing schema):
  program_id UUID,
  day_label TEXT,
  type TEXT,
  instructions TEXT,
  duration_minutes INTEGER
);

CREATE TABLE IF NOT EXISTS public.exercises (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  workout_id UUID REFERENCES public.workouts(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  sets INTEGER,
  reps INTEGER,
  weight_lbs NUMERIC(6,2),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.exercise_sets (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  exercise_id UUID REFERENCES public.exercises(id) ON DELETE CASCADE NOT NULL,
  set_number INTEGER NOT NULL,
  weight_lbs NUMERIC(6,2),
  reps INTEGER,
  completed BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.exercises_library (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  muscle_group TEXT NOT NULL,
  equipment TEXT,
  description TEXT,
  category TEXT
);

CREATE TABLE IF NOT EXISTS public.runs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  date DATE NOT NULL,
  type TEXT,
  distance_mi NUMERIC(5,2),
  duration_seconds INTEGER,
  pace_per_mile_seconds INTEGER,
  avg_hr INTEGER,
  max_hr INTEGER,
  avg_cadence INTEGER,
  elevation_ft INTEGER DEFAULT 0,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.body_weight_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  date DATE NOT NULL,
  weight_lbs NUMERIC(5,1) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.body_fat_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  date DATE NOT NULL,
  body_fat_pct NUMERIC(4,1) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.progress_photos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID,
  photo_url TEXT NOT NULL,
  label TEXT,
  filter_name TEXT,
  notes TEXT,
  taken_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.meal_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  date DATE NOT NULL,
  meal_name TEXT NOT NULL,
  calories INTEGER,
  protein_g NUMERIC(6,1),
  carbs_g NUMERIC(6,1),
  fat_g NUMERIC(6,1),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.nutrition_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  date DATE NOT NULL,
  eating_window_start TIME,
  eating_window_end TIME,
  carb_day_type TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.supplement_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  date DATE NOT NULL,
  name TEXT NOT NULL,
  dose TEXT,
  time_taken TIME,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.sleep_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID,
  date DATE NOT NULL,
  hours_slept NUMERIC(4,2),
  sleep_quality INTEGER CHECK (sleep_quality BETWEEN 1 AND 10),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.recovery_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  date DATE NOT NULL,
  sleep_hours NUMERIC(4,2),
  soreness_level INTEGER,
  mobility_done BOOLEAN,
  cold_therapy BOOLEAN,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.daily_goals (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  date DATE NOT NULL,
  goal_type TEXT NOT NULL,
  goal_description TEXT NOT NULL,
  target_value NUMERIC,
  target_unit TEXT,
  tokens_reward INTEGER,
  completed BOOLEAN DEFAULT false,
  completed_at TIMESTAMPTZ,
  ai_reasoning TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.ai_context (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID,
  week_start DATE NOT NULL,
  summary JSONB NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.form_videos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID,
  exercise_name TEXT NOT NULL,
  video_url TEXT NOT NULL,
  duration_seconds INTEGER,
  notes TEXT,
  recorded_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.teams (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  total_tokens INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  description TEXT,
  location TEXT,
  city TEXT,
  state TEXT,
  lat NUMERIC(9,6),
  lng NUMERIC(9,6),
  status TEXT DEFAULT 'active',
  max_members INTEGER DEFAULT 50,
  sport_focus TEXT,
  created_by UUID
);

CREATE TABLE IF NOT EXISTS public.team_members (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  team_id UUID,
  user_id UUID,
  tokens_contributed INTEGER DEFAULT 0,
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  is_lead BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS public.team_join_requests (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  team_id UUID NOT NULL,
  user_id UUID NOT NULL,
  message TEXT,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  responded_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS public.gyms (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  website TEXT,
  city TEXT,
  state TEXT,
  address TEXT,
  logo_url TEXT,
  cover_url TEXT,
  subscription_tier TEXT DEFAULT 'free',
  verified BOOLEAN DEFAULT false,
  created_by UUID,
  total_members INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.gym_members (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  gym_id UUID,
  user_id UUID,
  role TEXT DEFAULT 'member',
  joined_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.gym_merch (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  gym_id UUID,
  name TEXT NOT NULL,
  description TEXT,
  price_usd NUMERIC(8,2),
  image_url TEXT,
  purchase_url TEXT,
  available BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.events (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  event_type TEXT NOT NULL,
  host_type TEXT NOT NULL,
  host_id UUID NOT NULL,
  hosted_by UUID,
  event_date TIMESTAMPTZ NOT NULL,
  location_name TEXT,
  city TEXT,
  state TEXT,
  distance_miles NUMERIC(6,2),
  max_participants INTEGER,
  is_public BOOLEAN DEFAULT true,
  status TEXT DEFAULT 'upcoming',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.event_registrations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  event_id UUID,
  user_id UUID,
  registered_at TIMESTAMPTZ DEFAULT NOW(),
  result_value NUMERIC,
  result_unit TEXT,
  final_rank INTEGER
);

CREATE TABLE IF NOT EXISTS public.waitlist (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT NOT NULL,
  source TEXT,
  name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── COACH PORTAL TABLES ───────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.clients (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL,
  goal TEXT,
  training_background TEXT,
  days_per_week INTEGER DEFAULT 4,
  subscription_status TEXT DEFAULT 'inactive',
  subscription_start DATE,
  monthly_rate INTEGER DEFAULT 199,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.programs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  client_id UUID REFERENCES public.clients(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  start_date DATE,
  end_date DATE,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.assigned_workouts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  client_id UUID REFERENCES public.clients(id) ON DELETE CASCADE,
  workout_id UUID REFERENCES public.workouts(id) ON DELETE CASCADE,
  assigned_date DATE NOT NULL,
  completed BOOLEAN DEFAULT false,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.workout_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  client_id UUID REFERENCES public.clients(id) ON DELETE CASCADE,
  assigned_workout_id UUID REFERENCES public.assigned_workouts(id),
  notes TEXT,
  rpe INTEGER CHECK (rpe BETWEEN 1 AND 10),
  duration_actual INTEGER,
  logged_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.checkins (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  client_id UUID REFERENCES public.clients(id) ON DELETE CASCADE,
  week_of DATE NOT NULL,
  training_adherence INTEGER CHECK (training_adherence BETWEEN 1 AND 5),
  sleep_quality INTEGER CHECK (sleep_quality BETWEEN 1 AND 5),
  stress_level INTEGER CHECK (stress_level BETWEEN 1 AND 5),
  energy_level INTEGER CHECK (energy_level BETWEEN 1 AND 5),
  notes TEXT,
  submitted_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.coach_notes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  client_id UUID REFERENCES public.clients(id) ON DELETE CASCADE,
  note TEXT NOT NULL,
  is_visible_to_client BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.messages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  client_id UUID REFERENCES public.clients(id) ON DELETE CASCADE,
  sender TEXT NOT NULL CHECK (sender IN ('client','coach')),
  content TEXT NOT NULL,
  read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.progress_metrics (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  client_id UUID REFERENCES public.clients(id) ON DELETE CASCADE,
  recorded_date DATE NOT NULL,
  weight_lbs NUMERIC(5,1),
  resting_hr INTEGER,
  vo2max_estimate NUMERIC(4,1),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.subscriptions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  client_id UUID REFERENCES public.clients(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'active',
  start_date DATE NOT NULL,
  end_date DATE,
  monthly_rate INTEGER NOT NULL DEFAULT 199,
  payment_method TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.applications (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL,
  training_background TEXT,
  primary_goal TEXT,
  days_per_week INTEGER,
  additional_notes TEXT,
  status TEXT DEFAULT 'pending',
  submitted_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── LEADERBOARD VIEW ──────────────────────────────────────────────────────────

CREATE OR REPLACE VIEW public.leaderboard AS
SELECT p.id, p.name, p.subscription_tier, p.total_tokens, t.name AS team_name
FROM public.profiles p
LEFT JOIN public.team_members tm ON tm.user_id = p.id
LEFT JOIN public.teams t ON t.id = tm.team_id;

-- ── AUTO-CREATE PROFILE TRIGGER ───────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, name)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ── INDEXES ───────────────────────────────────────────────────────────────────

CREATE INDEX IF NOT EXISTS workouts_user_id_idx ON public.workouts(user_id);
CREATE INDEX IF NOT EXISTS workouts_date_idx ON public.workouts(date);
CREATE INDEX IF NOT EXISTS exercises_workout_id_idx ON public.exercises(workout_id);
CREATE INDEX IF NOT EXISTS runs_user_id_idx ON public.runs(user_id);
CREATE INDEX IF NOT EXISTS runs_date_idx ON public.runs(date);
CREATE INDEX IF NOT EXISTS assigned_workouts_client_id_idx ON public.assigned_workouts(client_id);
CREATE INDEX IF NOT EXISTS assigned_workouts_date_idx ON public.assigned_workouts(assigned_date);
CREATE INDEX IF NOT EXISTS messages_client_id_idx ON public.messages(client_id);
CREATE INDEX IF NOT EXISTS checkins_client_id_idx ON public.checkins(client_id);
