-- ═══════════════════════════════════════════════════════════════════════
-- AT0M FIT — FULL PREMIUM BUILDOUT SQL
-- Run AFTER AT0M_FIT_FEATURE_EXPANSION.sql (which creates progress_photos,
-- nutrition_plans, weekly_plan_items, client_goals).
-- Safe to run: does not drop or alter existing tables.
-- ═══════════════════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────
-- TABLE: community_posts
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.community_posts (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id    uuid NOT NULL REFERENCES public.clients(id) ON DELETE CASCADE,
  category     text NOT NULL DEFAULT 'general'
                 CHECK (category IN ('general','progress','wins','questions','accountability','milestones')),
  content      text NOT NULL,
  photo_url    text,
  display_name text,
  is_approved  boolean NOT NULL DEFAULT true,
  is_flagged   boolean NOT NULL DEFAULT false,
  created_at   timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.community_posts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Clients read approved posts"
  ON public.community_posts FOR SELECT
  USING (auth.role() = 'authenticated' AND is_approved = true);

CREATE POLICY "Clients create own posts"
  ON public.community_posts FOR INSERT
  WITH CHECK (auth.uid() = client_id);

CREATE POLICY "Clients delete own posts"
  ON public.community_posts FOR DELETE
  USING (auth.uid() = client_id);

CREATE POLICY "Coach manages all posts"
  ON public.community_posts FOR ALL
  USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ─────────────────────────────────────────────
-- TABLE: community_comments
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.community_comments (
  id        uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id   uuid NOT NULL REFERENCES public.community_posts(id) ON DELETE CASCADE,
  client_id uuid NOT NULL REFERENCES public.clients(id) ON DELETE CASCADE,
  content   text NOT NULL,
  display_name text,
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.community_comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Clients read comments on approved posts"
  ON public.community_comments FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Clients create own comments"
  ON public.community_comments FOR INSERT
  WITH CHECK (auth.uid() = client_id);

CREATE POLICY "Clients delete own comments"
  ON public.community_comments FOR DELETE
  USING (auth.uid() = client_id);

CREATE POLICY "Coach manages all comments"
  ON public.community_comments FOR ALL
  USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ─────────────────────────────────────────────
-- TABLE: community_reactions
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.community_reactions (
  id        uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id   uuid NOT NULL REFERENCES public.community_posts(id) ON DELETE CASCADE,
  client_id uuid NOT NULL REFERENCES public.clients(id) ON DELETE CASCADE,
  reaction  text NOT NULL DEFAULT 'fire' CHECK (reaction IN ('fire','strong','check','heart')),
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (post_id, client_id)
);
ALTER TABLE public.community_reactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Clients read reactions"
  ON public.community_reactions FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Clients manage own reactions"
  ON public.community_reactions FOR ALL
  USING (auth.uid() = client_id)
  WITH CHECK (auth.uid() = client_id);

-- ─────────────────────────────────────────────
-- TABLE: ask_atom_logs
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.ask_atom_logs (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id     uuid REFERENCES public.clients(id) ON DELETE SET NULL,
  client_email  text,
  question      text NOT NULL,
  answer        text,
  is_flagged    boolean NOT NULL DEFAULT false,
  flag_reason   text,
  model_used    text,
  tokens_used   integer,
  created_at    timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.ask_atom_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Clients read own ask_atom logs"
  ON public.ask_atom_logs FOR SELECT
  USING (auth.uid() = client_id);

CREATE POLICY "Clients insert own questions"
  ON public.ask_atom_logs FOR INSERT
  WITH CHECK (auth.uid() = client_id);

CREATE POLICY "Coach reads all ask_atom logs"
  ON public.ask_atom_logs FOR SELECT
  USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

CREATE POLICY "Coach updates flags"
  ON public.ask_atom_logs FOR UPDATE
  USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ─────────────────────────────────────────────
-- TABLE: readiness_scores
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.readiness_scores (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id     uuid NOT NULL REFERENCES public.clients(id) ON DELETE CASCADE,
  scored_at     date NOT NULL DEFAULT CURRENT_DATE,
  sleep_quality integer CHECK (sleep_quality BETWEEN 1 AND 5),
  soreness      integer CHECK (soreness BETWEEN 1 AND 5),
  stress        integer CHECK (stress BETWEEN 1 AND 5),
  energy        integer CHECK (energy BETWEEN 1 AND 5),
  motivation    integer CHECK (motivation BETWEEN 1 AND 5),
  readiness_pct integer GENERATED ALWAYS AS (
    ROUND(((sleep_quality + (6 - soreness) + (6 - stress) + energy + motivation)::numeric / 25) * 100)
  ) STORED,
  recommendation text,
  notes         text,
  created_at    timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.readiness_scores ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Clients manage own readiness"
  ON public.readiness_scores FOR ALL
  USING (auth.uid() = client_id)
  WITH CHECK (auth.uid() = client_id);

CREATE POLICY "Coach reads all readiness"
  ON public.readiness_scores FOR SELECT
  USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ─────────────────────────────────────────────
-- TABLE: client_badges
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.client_badges (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id   uuid NOT NULL REFERENCES public.clients(id) ON DELETE CASCADE,
  badge_key   text NOT NULL,
  badge_name  text NOT NULL,
  badge_desc  text,
  earned_at   timestamptz NOT NULL DEFAULT now(),
  UNIQUE (client_id, badge_key)
);
ALTER TABLE public.client_badges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Clients read own badges"
  ON public.client_badges FOR SELECT USING (auth.uid() = client_id);

CREATE POLICY "Coach manages all badges"
  ON public.client_badges FOR ALL
  USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ─────────────────────────────────────────────
-- TABLE: resource_vault
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.resource_vault (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title       text NOT NULL,
  category    text NOT NULL DEFAULT 'general',
  content     text,
  file_url    text,
  is_public   boolean NOT NULL DEFAULT false,
  sort_order  integer DEFAULT 0,
  created_at  timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.resource_vault ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated clients read resources"
  ON public.resource_vault FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Coach manages resources"
  ON public.resource_vault FOR ALL
  USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ─────────────────────────────────────────────
-- TABLE: exercise_library
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.exercise_library (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name         text NOT NULL,
  category     text,
  muscle_group text,
  equipment    text,
  instructions text,
  form_cues    text,
  video_url    text,
  coach_notes  text,
  created_at   timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.exercise_library ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated clients read exercises"
  ON public.exercise_library FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Coach manages exercise library"
  ON public.exercise_library FOR ALL
  USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ─────────────────────────────────────────────
-- TABLE: coach_alerts
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.coach_alerts (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id    uuid REFERENCES public.clients(id) ON DELETE SET NULL,
  alert_type   text NOT NULL,
  message      text NOT NULL,
  is_resolved  boolean NOT NULL DEFAULT false,
  created_at   timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.coach_alerts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Coach manages all alerts"
  ON public.coach_alerts FOR ALL
  USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ─────────────────────────────────────────────
-- TABLE: weekly_reports
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.weekly_reports (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id       uuid NOT NULL REFERENCES public.clients(id) ON DELETE CASCADE,
  week_of         date NOT NULL,
  summary         text,
  coach_feedback  text,
  workouts_done   integer DEFAULT 0,
  checkin_done    boolean DEFAULT false,
  avg_readiness   integer,
  is_visible      boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.weekly_reports ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Clients read own weekly reports"
  ON public.weekly_reports FOR SELECT
  USING (auth.uid() = client_id);

CREATE POLICY "Coach manages all weekly reports"
  ON public.weekly_reports FOR ALL
  USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ─────────────────────────────────────────────
-- INDEXES
-- ─────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_community_posts_cat   ON public.community_posts(category, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_community_comments_post ON public.community_comments(post_id);
CREATE INDEX IF NOT EXISTS idx_ask_atom_logs_client  ON public.ask_atom_logs(client_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_readiness_client      ON public.readiness_scores(client_id, scored_at DESC);
CREATE INDEX IF NOT EXISTS idx_client_badges_client  ON public.client_badges(client_id);
CREATE INDEX IF NOT EXISTS idx_weekly_reports_client ON public.weekly_reports(client_id, week_of DESC);

-- ─────────────────────────────────────────────
-- SEED: default badges (coach can award these)
-- ─────────────────────────────────────────────
-- INSERT INTO public.resource_vault (title, category, content, is_public, sort_order) VALUES
-- ('Zone 2 Training Guide', 'training', 'Train at 60-70% max HR...', false, 1),
-- ('Grocery List — Performance', 'nutrition', 'Lean proteins, complex carbs...', false, 2),
-- ...
-- Uncomment and fill in content after setup.
