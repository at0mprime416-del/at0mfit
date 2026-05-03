# AT0M FIT — Client Workflow

---

## End-to-End Client Journey

### Stage 1: Discover

Client finds AT0M FIT via search, social media, or referral.

**Entry points:**
- Google search → /calculator (zone education → upsell)
- Social → /blueprint (ebook purchase → upsell)
- Direct referral → /training (straight to application)

---

### Stage 2: Engage

**Free Zone Calculator (/calculator)**
- Client enters age or max HR
- Tool outputs 5 HR zones with descriptions
- CTA bridges to Blueprint or Custom Training

**Levi Cardio Blueprint (/blueprint)**
- Client reads about methodology and Levi's case study
- CTA: "Get the Blueprint" → Gumroad checkout ($27)
- Gumroad delivers PDF instantly
- Client validates the methodology → considers Custom Training

---

### Stage 3: Apply

**Training Page (/training)**
- Client reads offer details, sees $199/month, sees "Apply" CTA
- Clicks "Apply for Custom Training"
- Modal form opens with fields:
  - Full name
  - Email address
  - Training background
  - Primary goal
  - Days available per week
  - Additional notes
- Client submits form
- Row inserted to `applications` table (no login required)

---

### Stage 4: Await Approval

- Coach reviews application in /coach dashboard
- Coach marks application "Reviewed"
- Coach contacts client manually (email or DM)
- If approved: coach informs client they're accepted

---

### Stage 5: Account Created

- Coach creates auth account for client in Supabase Dashboard (Authentication → Users)
- Coach creates row in `clients` table (or via future coach dashboard form)
- Coach sends client their login credentials
- Coach creates initial program in /coach dashboard

---

### Stage 6: Login

- Client visits at0mfit.com/portal
- Enters email + password
- Auth gate passes → dashboard loads

**Portal dashboard shows:**
- Welcome message with client name
- This week's assigned workout
- Weekly check-in form
- Message thread with coach
- Progress snapshot sidebar (weight, last check-in, sessions this week)
- Coach notes (if any)

---

### Stage 7: View Assigned Workout

- Dashboard shows the workout assigned for this week
- Displays: workout name, type badge (zone2/strength/etc.), date, duration (minutes), instructions
- If no workout assigned: placeholder message shown

---

### Stage 8: Log Workout

- Client completes workout
- Fills log form in portal:
  - RPE (1–10)
  - Actual duration (minutes)
  - Notes (optional)
- Submits → inserted to `workout_logs` table
- Coach can see this log in /coach dashboard

---

### Stage 9: Weekly Check-in

- Every week, client fills out check-in form:
  - Training Adherence (1–5)
  - Sleep Quality (1–5)
  - Stress Level (1–5)
  - Energy Level (1–5)
  - Notes for coach (free text)
- Submits → inserted to `checkins` table
- Coach reviews in dashboard

---

### Stage 10: Message Coach

- Client types message in portal message thread
- Stored with `sender = 'client'` in `messages` table
- Coach sees message in /coach dashboard
- Coach replies → stored with `sender = 'coach'`
- Client sees reply in portal thread on next visit

---

### Stage 11: Track Progress

**Portal sidebar shows:**
- Current weight (from `progress_metrics` — coach-entered)
- Last check-in date
- Sessions completed this week (completed assigned workouts)

**Coach notes section:**
- Any notes coach has marked visible to client appear here

**Future (not yet built):**
- Check-in history graph
- Workout log history
- Progress photos via mobile app

---

## Supabase Tables Used by Client

| Table | Client Access |
|-------|--------------|
| clients | SELECT own row only |
| assigned_workouts | SELECT own rows (this week's workout) |
| workouts | Accessed via JOIN with assigned_workouts |
| workout_logs | SELECT + INSERT own rows |
| checkins | SELECT + INSERT own rows |
| messages | SELECT own thread + INSERT (sender='client') |
| coach_notes | SELECT where is_visible_to_client = true |
| progress_metrics | SELECT own rows |
