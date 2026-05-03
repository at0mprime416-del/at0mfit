# AT0M FIT — Coach Workflow

---

## Coach Access

- **URL:** at0mfit.com/coach
- **Login:** jeshua@levioperations.com
- **Gate:** Client-side email check + Supabase RLS (email claim in JWT)
- **Note:** Coach password was set via DB during QA. Should be reset via Supabase Dashboard.

---

## Complete Coach Journey

### Step 1: Login

1. Visit at0mfit.com/coach
2. Enter email + password
3. Supabase auth returns JWT with email claim
4. coach.html checks: `if (user.email !== 'jeshua@levioperations.com') → signOut()`
5. If mismatch: show "Access Restricted" screen + sign out
6. If match: load coach dashboard

**What loads:**
- Applications queue (pending)
- Client roster
- Active client detail panels
- Message threads

---

### Step 2: Review Applications

**Applications Queue panel:**
- Shows all applications with `status = 'pending'`
- Displays: Full name, email, primary goal, training background, days/week, notes, submitted date
- Sorted by `created_at` descending (newest first)

**Action: Mark Reviewed**
- Click "Mark Reviewed" → updates `status` to `'reviewed'` in `applications` table
- Application removed from pending queue

**Next step (manual):**
- Coach contacts applicant via email or DM
- If accepting: proceed to create client account (Step 3)
- If declining: no automated action needed

---

### Step 3: Accept Client (Manual Process — UI Not Built Yet)

**Current manual flow:**
1. Go to Supabase Dashboard → Authentication → Users → Invite/Create User
2. Create auth account with client's email
3. Note the user's UUID (shown in Supabase dashboard)
4. Insert row to `clients` table:
   ```sql
   INSERT INTO public.clients (id, full_name, email, subscription_status, days_per_week, goal)
   VALUES ('[uuid]', 'Client Name', 'client@email.com', 'active', 4, 'Build aerobic base');
   ```
5. Send login credentials to client

**Planned (not yet built):** "Accept Application" button in coach.html that automates account creation via Supabase Admin API (requires service role key server-side endpoint).

---

### Step 4: Create Program

**In coach.html → Client detail panel:**
1. Select client from roster
2. Click "Create Program"
3. Fill form: Program Name, Description, Start Date
4. Submit → inserts to `programs` table with `client_id = client.id`

---

### Step 5: Assign Workout

**In coach.html → Client detail panel → Program:**
1. Click "Assign Workout"
2. Fill form:
   - Workout Name (e.g., "Zone 2 Run — Monday")
   - Type (zone2 / strength / zone4 / recovery / tempo)
   - Day Label (e.g., "Monday", "Day 1")
   - Duration (minutes)
   - Instructions (full text — client sees this in portal)
   - Date (assigned date)
3. Submit →
   - Inserts row to `workouts` table (`user_id = client.id`, `program_id = program.id`)
   - Inserts row to `assigned_workouts` table (`client_id = client.id`, `workout_id = workout.id`, `assigned_date`)

**Key:** `workouts.user_id` must be the client's Supabase auth UUID, not the coach's UUID. This enables client RLS to work correctly.

---

### Step 6: Review Workout Logs

**In client detail panel:**
- Workout logs appear automatically as clients submit them
- Displays: workout name, RPE, actual duration, notes, timestamp
- Read-only for coach in current UI

---

### Step 7: Review Check-ins

**In client detail panel:**
- Latest check-in shown by default (can scroll history — planned)
- Displays: training adherence, sleep quality, stress level, energy level (1-5 each), notes, week of

---

### Step 8: Message Client

**In client message thread:**
1. Type message in coach input
2. Send → inserts to `messages` with `sender = 'coach'`, `client_id = client.id`
3. Client sees message in /portal message thread
4. When client replies: message appears in coach thread with `sender = 'client'`

**No push notifications yet** — coach must check dashboard manually.

---

### Step 9: Monitor Progress

**Client detail panel sidebar:**
- Latest weight, resting HR, VO2 estimate (from `progress_metrics` — coach-entered)
- Session count (completed assigned workouts)
- Last check-in date

**Coach Notes (not yet built in UI):**
- DB table `coach_notes` exists
- `is_visible_to_client` flag controls client visibility
- Add notes form not yet in coach.html

---

## Supabase Tables Used by Coach

| Table | Coach Access |
|-------|-------------|
| clients | SELECT all (read full roster) |
| applications | SELECT + UPDATE all (review queue) |
| programs | SELECT + INSERT all clients |
| workouts | INSERT (create for clients) |
| assigned_workouts | SELECT + INSERT all clients |
| workout_logs | SELECT all clients |
| checkins | SELECT all clients |
| messages | SELECT + INSERT all clients (sender='coach') |
| coach_notes | ALL (full CRUD) |
| progress_metrics | SELECT all clients |

All coach policies use: `auth.jwt() ->> 'email' = 'jeshua@levioperations.com'`

---

## Coach Dashboard File

`at0mfit/coach.html` — 1,521 lines, 57KB  
Self-contained: inline CSS, inline JS, Supabase JS via CDN  
No external dependencies beyond Google Fonts + Supabase CDN
