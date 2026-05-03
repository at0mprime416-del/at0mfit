-- ════════════════════════════════════════════════════════════════════
-- AT0M FIT — FINAL HARDENING SETUP
-- Run this in the Supabase SQL editor (Project > SQL Editor > New Query)
-- Run AFTER AT0M_FIT_FEATURE_EXPANSION.sql and FULL_PREMIUM_BUILDOUT_SETUP.sql
-- ════════════════════════════════════════════════════════════════════

-- ────────────────────────────────────────────────────────────────────
-- TABLE 1: client_onboarding_tasks
-- Tracks client onboarding checklist completion
-- ────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.client_onboarding_tasks (
  id             UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  client_id      UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  task_key       TEXT NOT NULL,
  completed      BOOLEAN DEFAULT false,
  completed_at   TIMESTAMPTZ,
  created_at     TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.client_onboarding_tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Clients read own onboarding tasks" ON public.client_onboarding_tasks
  FOR SELECT USING (auth.uid() = client_id);

CREATE POLICY "Clients update own onboarding tasks" ON public.client_onboarding_tasks
  FOR UPDATE USING (auth.uid() = client_id);

CREATE POLICY "Coach reads all onboarding tasks" ON public.client_onboarding_tasks
  FOR SELECT USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

CREATE POLICY "Coach inserts onboarding tasks" ON public.client_onboarding_tasks
  FOR INSERT WITH CHECK (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ────────────────────────────────────────────────────────────────────
-- TABLE 2: support_requests
-- Stores client support requests from /support page
-- ────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.support_requests (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  client_id    UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  name         TEXT NOT NULL,
  email        TEXT NOT NULL,
  issue_type   TEXT NOT NULL,
  message      TEXT NOT NULL,
  status       TEXT NOT NULL DEFAULT 'open',
  created_at   TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.support_requests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public can insert support requests" ON public.support_requests
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Clients read own support requests" ON public.support_requests
  FOR SELECT USING (auth.uid() = client_id);

CREATE POLICY "Coach reads all support requests" ON public.support_requests
  FOR SELECT USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

CREATE POLICY "Coach updates support requests" ON public.support_requests
  FOR UPDATE USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ────────────────────────────────────────────────────────────────────
-- TABLE 3: client_admin_status
-- Coach-managed admin flags per client
-- ────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.client_admin_status (
  id               UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  client_id        UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  active           BOOLEAN DEFAULT true,
  founding_client  BOOLEAN DEFAULT false,
  payment_status   TEXT DEFAULT 'pending',
  tags             TEXT[] DEFAULT '{}',
  risk_flag        BOOLEAN DEFAULT false,
  risk_reason      TEXT,
  coach_notes      TEXT,
  created_at       TIMESTAMPTZ DEFAULT now(),
  updated_at       TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.client_admin_status ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Coach manages all client admin status" ON public.client_admin_status
  FOR ALL USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ────────────────────────────────────────────────────────────────────
-- TABLE 4: activity_log
-- Platform-wide audit trail of key events
-- ────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.activity_log (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  client_id    UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  event_type   TEXT NOT NULL,
  summary      TEXT NOT NULL,
  metadata     JSONB DEFAULT '{}',
  created_at   TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.activity_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Coach reads all activity logs" ON public.activity_log
  FOR SELECT USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

CREATE POLICY "Service role inserts activity logs" ON public.activity_log
  FOR INSERT WITH CHECK (true);

-- ────────────────────────────────────────────────────────────────────
-- TABLE 5: legal_acceptances
-- Tracks when clients accept legal documents
-- ────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.legal_acceptances (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  client_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  document_type   TEXT NOT NULL,
  accepted_at     TIMESTAMPTZ DEFAULT now(),
  ip_address      TEXT,
  user_agent      TEXT
);

ALTER TABLE public.legal_acceptances ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Clients read own legal acceptances" ON public.legal_acceptances
  FOR SELECT USING (auth.uid() = client_id);

CREATE POLICY "Clients insert own legal acceptances" ON public.legal_acceptances
  FOR INSERT WITH CHECK (auth.uid() = client_id);

CREATE POLICY "Coach reads all legal acceptances" ON public.legal_acceptances
  FOR SELECT USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ────────────────────────────────────────────────────────────────────
-- INDEXES FOR PERFORMANCE
-- ────────────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_onboarding_client ON public.client_onboarding_tasks(client_id);
CREATE INDEX IF NOT EXISTS idx_support_email ON public.support_requests(email);
CREATE INDEX IF NOT EXISTS idx_support_status ON public.support_requests(status);
CREATE INDEX IF NOT EXISTS idx_admin_status_client ON public.client_admin_status(client_id);
CREATE INDEX IF NOT EXISTS idx_activity_client ON public.activity_log(client_id);
CREATE INDEX IF NOT EXISTS idx_activity_event ON public.activity_log(event_type);
CREATE INDEX IF NOT EXISTS idx_activity_created ON public.activity_log(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_legal_client ON public.legal_acceptances(client_id);

-- ────────────────────────────────────────────────────────────────────
-- COMMUNITY MODERATION: ADD HIDDEN COLUMN IF NOT EXISTS
-- Extends community_posts and community_comments tables (if they exist)
-- ────────────────────────────────────────────────────────────────────
ALTER TABLE IF EXISTS public.community_posts ADD COLUMN IF NOT EXISTS hidden BOOLEAN DEFAULT false;
ALTER TABLE IF EXISTS public.community_posts ADD COLUMN IF NOT EXISTS moderation_status TEXT DEFAULT 'visible';
ALTER TABLE IF EXISTS public.community_comments ADD COLUMN IF NOT EXISTS hidden BOOLEAN DEFAULT false;

-- Coach can update community posts moderation
CREATE POLICY IF NOT EXISTS "Coach moderates community posts" ON public.community_posts
  FOR UPDATE USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

CREATE POLICY IF NOT EXISTS "Coach moderates community comments" ON public.community_comments
  FOR UPDATE USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ────────────────────────────────────────────────────────────────────
-- ASK AT0M: ADD COACH REVIEW COLUMNS IF NOT EXISTS
-- Extends ask_atom_logs table (if it exists)
-- ────────────────────────────────────────────────────────────────────
ALTER TABLE IF EXISTS public.ask_atom_logs ADD COLUMN IF NOT EXISTS coach_reviewed BOOLEAN DEFAULT false;
ALTER TABLE IF EXISTS public.ask_atom_logs ADD COLUMN IF NOT EXISTS coach_reviewed_at TIMESTAMPTZ;

CREATE POLICY IF NOT EXISTS "Coach reads all ask_atom_logs" ON public.ask_atom_logs
  FOR SELECT USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

CREATE POLICY IF NOT EXISTS "Coach updates ask_atom_logs" ON public.ask_atom_logs
  FOR UPDATE USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');

-- ════════════════════════════════════════════════════════════════════
-- END OF FINAL_HARDENING_SETUP.sql
-- After running: restart the API server workflow in Replit
-- ════════════════════════════════════════════════════════════════════
