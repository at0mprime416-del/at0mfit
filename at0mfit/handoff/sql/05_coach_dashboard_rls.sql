-- ============================================================
-- AT0M FIT — Block 5: Coach Dashboard RLS Policies
-- All coach policies use the email claim from the JWT:
--   auth.jwt() ->> 'email' = 'jeshua@levioperations.com'
--
-- This means ONLY the authenticated user with that email
-- can access these tables in the coach role.
--
-- Client-side: coach.html also checks user.email on login.
-- DB-side: these RLS policies are the real enforcement.
-- ============================================================

DO $$ BEGIN

  -- Coach reads all clients (full roster)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='clients' AND policyname='Coach reads all clients') THEN
    CREATE POLICY "Coach reads all clients" ON public.clients
      FOR SELECT USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');
  END IF;

  -- Coach reads all applications (intake queue)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='applications' AND policyname='Coach reads all applications') THEN
    CREATE POLICY "Coach reads all applications" ON public.applications
      FOR SELECT USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');
  END IF;

  -- Coach updates applications (mark reviewed/approved/declined)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='applications' AND policyname='Coach updates applications') THEN
    CREATE POLICY "Coach updates applications" ON public.applications
      FOR UPDATE USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');
  END IF;

  -- Coach reads all messages (all client threads)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='messages' AND policyname='Coach reads all messages') THEN
    CREATE POLICY "Coach reads all messages" ON public.messages
      FOR SELECT USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');
  END IF;

  -- Coach sends messages (reply to any client thread)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='messages' AND policyname='Coach sends messages') THEN
    CREATE POLICY "Coach sends messages" ON public.messages
      FOR INSERT WITH CHECK (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');
  END IF;

  -- Coach reads all check-ins (review client adherence)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='checkins' AND policyname='Coach reads all checkins') THEN
    CREATE POLICY "Coach reads all checkins" ON public.checkins
      FOR SELECT USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');
  END IF;

  -- Coach reads all workout logs (review client completion)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='workout_logs' AND policyname='Coach reads all workout logs') THEN
    CREATE POLICY "Coach reads all workout logs" ON public.workout_logs
      FOR SELECT USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');
  END IF;

  -- Coach reads all assigned workouts (view schedule)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='assigned_workouts' AND policyname='Coach reads all assigned workouts') THEN
    CREATE POLICY "Coach reads all assigned workouts" ON public.assigned_workouts
      FOR SELECT USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');
  END IF;

  -- Coach assigns workouts (insert assigned_workouts rows)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='assigned_workouts' AND policyname='Coach assigns workouts') THEN
    CREATE POLICY "Coach assigns workouts" ON public.assigned_workouts
      FOR INSERT WITH CHECK (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');
  END IF;

  -- Coach inserts workouts (create workout templates for clients)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='workouts' AND policyname='Coach inserts workouts') THEN
    CREATE POLICY "Coach inserts workouts" ON public.workouts
      FOR INSERT WITH CHECK (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');
  END IF;

  -- Coach inserts programs (create programs for clients)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='programs' AND policyname='Coach inserts programs') THEN
    CREATE POLICY "Coach inserts programs" ON public.programs
      FOR INSERT WITH CHECK (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');
  END IF;

  -- Coach reads programs (view all client programs)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='programs' AND policyname='Coach reads all programs') THEN
    CREATE POLICY "Coach reads all programs" ON public.programs
      FOR SELECT USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');
  END IF;

  -- Coach full access to coach notes (CRUD)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='coach_notes' AND policyname='Coach manages coach notes') THEN
    CREATE POLICY "Coach manages coach notes" ON public.coach_notes
      FOR ALL USING (auth.jwt() ->> 'email' = 'jeshua@levioperations.com');
  END IF;

END $$;

-- ── IF COACH EMAIL EVER CHANGES ───────────────────────────────────────────────
-- You must update all 13 policies above AND the COACH_EMAIL constant in coach.html.
-- To update all policies at once:
--
-- DO $$ DECLARE old_email TEXT := 'jeshua@levioperations.com';
--            new_email TEXT := 'newcoach@email.com';
-- BEGIN
--   -- Drop and recreate each policy with new email
--   -- Or use a function/loop
-- END $$;
