# AT0M FIT — Route Map

**Production domain:** https://at0mfit.com  
**Vercel alias:** https://at0mfit.vercel.app  
**Confirmed:** 2026-05-03 — all routes return HTTP 200

---

## Live Routes

| Route | File | Auth Required | Description |
|-------|------|--------------|-------------|
| `/` | index.html | No | Homepage — hero, features, waitlist CTA |
| `/blueprint` | blueprint.html | No | Levi Cardio Blueprint page — ebook offer |
| `/calculator` | calculator.html | No | HR Zone Calculator (interactive JS tool) |
| `/training` | training.html | No | Custom Training offer + application modal |
| `/portal` | portal.html | Yes (Supabase auth) | Client Dashboard |
| `/coach` | coach.html | Yes (email gate + Supabase auth) | Coach Dashboard |

---

## Route Config (vercel.json)

```json
{
  "version": 2,
  "routes": [
    { "src": "/blueprint",  "dest": "/blueprint.html" },
    { "src": "/calculator", "dest": "/calculator.html" },
    { "src": "/training",   "dest": "/training.html" },
    { "src": "/portal",     "dest": "/portal.html" },
    { "src": "/coach",      "dest": "/coach.html" },
    { "src": "/(.*)",       "dest": "/$1" }
  ]
}
```

The catch-all `(.*)` rule at the end handles direct asset requests (images, fonts, etc.).

---

## Auth Gate Details

### /portal
- Supabase email + password login
- Any valid Supabase auth user can access
- Client data is scoped by RLS (`auth.uid() = client_id`)
- If not logged in: login form is shown

### /coach
- Supabase email + password login
- Additional client-side gate: `if (user.email !== 'jeshua@levioperations.com') → signOut()`
- Supabase RLS also enforces by email claim for all coach tables
- If wrong email: shows "Access Restricted" screen

---

## No Dynamic Routes

This is a static HTML site. There are no:
- Server-side route handlers
- API routes
- Dynamic path segments (e.g., /clients/:id)
- Next.js/Nuxt/SvelteKit pages

All data fetching happens client-side via Supabase JS SDK.

---

## Planned Routes (Not Yet Built)

| Route | Purpose |
|-------|---------|
| `/api/checkout` | Future: Stripe checkout session (requires Vercel function or server) |
| `/api/webhook/stripe` | Future: Stripe webhook handler |
| `/api/notify` | Future: Application notification endpoint (Resend) |
