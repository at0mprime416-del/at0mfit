# AT0M FIT — API Integration Map

---

## Active Integrations

### Supabase
- **Role:** Database (PostgreSQL) + Auth + RLS enforcement
- **Project:** kgozddcutazpqmfbzafa.supabase.co
- **SDK:** `@supabase/supabase-js` (CDN in HTML files, npm in mobile app)
- **Auth method:** Email/password. Signups disabled — accounts created manually.
- **Used in:** All 6 HTML pages, at0mfit-app/src/lib/supabase.js
- **Keys needed:** SUPABASE_URL, SUPABASE_ANON_KEY (frontend), SUPABASE_SERVICE_ROLE_KEY (server-side only)
- **Dashboard:** https://supabase.com/dashboard/project/kgozddcutazpqmfbzafa

```javascript
// How it's initialized in HTML pages
const SUPABASE_URL = 'https://kgozddcutazpqmfbzafa.supabase.co';
const SUPABASE_ANON_KEY = '[anon key]';
const sb = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
```

### Vercel
- **Role:** Static hosting + CDN
- **Project ID:** prj_mwytZpFWdELjcVOceVV0PlJ446jr
- **Production domains:** at0mfit.com, www.at0mfit.com, at0mfit.vercel.app
- **Deploy method:** `vercel deploy --prod` (direct) or GitHub push → preview
- **Key needed:** VERCEL_TOKEN
- **Dashboard:** https://vercel.com/at0mprime416-dels-projects/at0mfit

### Gumroad
- **Role:** Blueprint ebook checkout + PDF delivery ($27)
- **Integration:** External link only — no API calls from our code
- **Our role:** /blueprint page links out to Gumroad product page
- **Gumroad handles:** Payment, PDF delivery, confirmation email
- **No code changes needed** unless migrating to different checkout

### OpenAI
- **Role:** AI workout generation (mobile app only)
- **Model:** gpt-4o
- **Used in:** at0mfit-app/src/lib/aiGoals.js
- **Functions:** generateDailyGoal(), generateAIWorkout(), buildUserContext()
- **Key needed:** EXPO_PUBLIC_OPENAI_API_KEY (mobile) / OPENAI_API_KEY (server-side)
- **Cost:** ~$0.01–0.05 per AI brief generation (gpt-4o pricing)

### Google Maps
- **Role:** GPS live run tracking (mobile app only)
- **SDK:** react-native-maps
- **Config:** app.json (iOS config.googleMapsApiKey, Android config.googleMaps.apiKey)
- **Key needed:** GOOGLE_MAPS_API_KEY
- **Used in:** LiveRunScreen.js
- **Enable in Google Cloud Console:** Maps SDK for Android + Maps SDK for iOS

### Expo / EAS
- **Role:** Mobile app development + build distribution
- **Project ID:** 043c2507-50b3-45d9-9a95-8412a51605db
- **Owner:** at0mprime (Expo account)
- **Build command:** `eas build --platform android --profile preview`
- **Not currently required** for web site work

---

## Not Yet Integrated (Future)

### Stripe
- **Planned role:** Recurring billing ($199/month subscription)
- **Trigger:** Activate at 10+ clients
- **What's needed:**
  - Stripe account + product created
  - Server-side endpoint for checkout session creation
  - Webhook handler for subscription lifecycle events
  - STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET, STRIPE_PRICE_ID

### Resend
- **Planned role:** Transactional email (client onboarding, application notifications)
- **Already used:** Blueprint delivery email (Gumroad-side, not our code)
- **What's needed:** RESEND_API_KEY, verified domain for sending
- **Priority:** Build application notification webhook first (low effort, high value)

### Discord
- **Planned role:** Coach notifications for new applications (optional)
- **What's needed:** Discord webhook URL
- **Alternative:** Resend email is simpler and already planned

---

## CDN Dependencies (in HTML pages)

```html
<!-- Supabase JS SDK -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/dist/umd/supabase.min.js"></script>

<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
```

No other external JS dependencies. All other functionality is vanilla JS.
