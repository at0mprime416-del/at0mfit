# Replit Import Steps

Follow these steps in order. Do not skip.

---

## Step 1 — Import from GitHub

1. Go to [replit.com](https://replit.com)
2. Click **Create Repl**
3. Select **Import from GitHub**
4. Connect your GitHub account: `at0mprime416-del`
5. Select repo: `at0mfit`
6. Select branch: **`master`** (NOT `main` — `main` is an old Next.js prototype)
7. Language: select **HTML** or **Static** if prompted
8. Click Import

---

## Step 2 — Set Secrets

In Replit → **Settings** → **Secrets** panel, add these keys (values from your secure storage):

| Secret Name | Where to Get It |
|-------------|----------------|
| `SUPABASE_URL` | Supabase Dashboard → Settings → API → Project URL |
| `SUPABASE_ANON_KEY` | Supabase Dashboard → Settings → API → anon/public key |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase Dashboard → Settings → API → service_role key |
| `VERCEL_TOKEN` | Vercel Dashboard → Account Settings → Tokens → Create |
| `VERCEL_PROJECT_ID` | `prj_mwytZpFWdELjcVOceVV0PlJ446jr` |
| `OPENAI_API_KEY` | OpenAI Dashboard → API Keys |
| `GOOGLE_MAPS_API_KEY` | Google Cloud Console → APIs & Services → Credentials |

See `env/.env.example` for the full variable list.

---

## Step 3 — Verify Structure

In Replit's file explorer, confirm you see:

```
at0mfit/
├── index.html
├── blueprint.html
├── calculator.html
├── training.html
├── portal.html
├── coach.html
├── vercel.json
├── package.json
└── *.png / *.jpg (image assets)
```

The `at0mfit/` folder is what gets deployed. Edit files inside here.

---

## Step 4 — Install Vercel CLI (one-time)

Open Replit Shell and run:

```bash
npm install -g vercel
```

---

## Step 5 — Verify Production Site is Live

```bash
curl -s -o /dev/null -w "%{http_code}" "https://at0mfit.vercel.app/"
# Expected: 200

curl -s -o /dev/null -w "%{http_code}" "https://at0mfit.vercel.app/coach"
# Expected: 200

curl -s -o /dev/null -w "%{http_code}" "https://at0mfit.vercel.app/portal"
# Expected: 200
```

---

## Step 6 — Make a Test Edit and Deploy

1. Open `at0mfit/index.html` in Replit editor
2. Find the page title or hero heading
3. Make a minor visible change (e.g., add a space or fix a word)
4. Save the file

Deploy to production:
```bash
cd at0mfit
vercel deploy --prod --yes --token $VERCEL_TOKEN
```

5. Wait for deploy to complete (~15-30 seconds)
6. Visit https://at0mfit.com — confirm the change is visible
7. Revert the test change, redeploy

---

## Step 7 — Fix Auto-Deploy (Optional but Recommended)

Currently, GitHub push triggers a **preview deploy** only. To make pushes auto-deploy to production:

1. Go to [Vercel Dashboard](https://vercel.com/at0mprime416-dels-projects/at0mfit/settings/git)
2. Under **Git** → **Production Branch**
3. Change from `main` to `master`
4. Save

After this: `git push origin master` will auto-deploy to production.

---

## Step 8 — Confirm Coach and Portal Auth

1. Open https://at0mfit.com/coach in a browser
2. Log in with `jeshua@levioperations.com` + current password
3. Confirm coach dashboard loads with applications queue and client roster

4. Open https://at0mfit.com/portal in a browser (or incognito)
5. Log in with a test client account
6. Confirm portal loads with this week's workout visible

If either auth flow fails, check `KNOWN_BUGS_AND_RISKS.md` → "Previously Fixed Issues" section.

---

## Ongoing Deploy Workflow

```bash
# 1. Edit file in at0mfit/
# 2. Commit + push to GitHub
cd at0mfit
git add -A
git commit -m "describe your change"
git push origin master

# 3. Deploy to production
vercel deploy --prod --yes --token $VERCEL_TOKEN
```

Or, after Step 7, just push to master and Vercel auto-deploys.

---

## Database Changes (When Needed)

For any Supabase schema changes:
1. Write the SQL
2. Go to [Supabase SQL Editor](https://supabase.com/dashboard/project/kgozddcutazpqmfbzafa/sql/new)
3. Paste and run
4. If you added columns: restart PostgREST (Supabase Dashboard → Settings → Infrastructure → Restart PostgREST)
5. Test the change before deploying frontend changes that depend on it

---

## Mobile App (Separate Track)

If working on `at0mfit-app/` (Expo mobile app):

```bash
cd at0mfit-app
npm install
cp ../env/.env.example .env
# Fill in .env values
npm start
# Follow Expo CLI instructions
```

Mobile app work is not required for web site operations.
