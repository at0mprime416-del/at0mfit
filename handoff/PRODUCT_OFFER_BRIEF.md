# AT0M FIT — Product & Offer Brief

---

## Brand Position

AT0M FIT is a tactical fitness brand built by Jeshua (Levi) — a SWAT operator and high-performance athlete. The brand sells zone-based cardio methodology, hybrid performance training, and 1-on-1 custom coaching.

**Target:** Serious athletes, military/LE/first responders, tactical athletes, hybrid runners  
**Differentiator:** Real operator data, structured zones, no generic content  
**Entity:** Levi Operations LLC

---

## Product Ladder

### 1. Free HR Zone Calculator
- **URL:** at0mfit.com/calculator
- **Price:** Free
- **Format:** Interactive web tool
- **Input:** Age (Karvonen formula) or manual max HR
- **Output:** 5 HR zones with ranges, descriptions, training purpose
- **CTA out:** Apply for Custom Training / Get the Blueprint
- **Purpose:** Lead gen, trust builder, SEO entry point

### 2. Levi Cardio Blueprint — Zone 2 to Zone 4
- **URL:** at0mfit.com/blueprint (landing) → Gumroad (checkout)
- **Price:** $27
- **Format:** PDF ebook (10 chapters + appendices)
- **Delivery:** Gumroad (instant) + Resend confirmation email
- **Content:**
  - Zone theory and training purpose
  - Levi's personal case study and data
  - Apple Watch and Fitness app setup
  - Zone 2 → Zone 4 progression protocol
  - Appendices: fuel by zone, recovery pairing, supplement basics
- **Levi's zones:** Z1 <132 | Z2 132-146 | Z3 147-160 | Z4 161-174 | Z5 175+ bpm
- **Key data:** Resting HR 49, max HR 188, 212→196.6 lbs, cadence 150s→180s
- **CTA:** "Get the Blueprint"

### 3. AT0M FIT Custom Training
- **URL:** at0mfit.com/training (offer) → /portal (client dashboard)
- **Price:** $199/month (founding price)
- **Format:** 1-on-1 coaching via web portal
- **Includes:**
  - Custom program design
  - Weekly workout assignments
  - Weekly check-in review
  - Direct messaging with coach
  - Progress tracking
- **Billing:** Manual for first 10 clients (Venmo/PayPal/Zelle)
- **Capacity:** Limited — founding spots only at $199
- **Price note:** Will increase after founding spots fill
- **Application CTA:** "Apply for Custom Training"
- **Portal:** at0mfit.com/portal (requires auth)
- **Coach dashboard:** at0mfit.com/coach (Jeshua only)

### 4. 8-Week Program (Future)
- **Status:** Not built
- **Planned price:** ~$97
- **Format:** TBD (PDF or portal-delivered)
- **Position:** Mid-tier between Blueprint ($27) and Custom Training ($199)
- **Do not build until explicitly instructed**

---

## Current Pricing

| Product | Price | Billing | Status |
|---------|-------|---------|--------|
| Zone Calculator | Free | — | Live |
| Levi Cardio Blueprint | $27 | Gumroad (one-time) | Live |
| Custom Training | $199/month | Manual | Live, accepting applications |
| 8-Week Program | ~$97 | TBD | Not built |

---

## CTA Language (Currently Live)

| Page | Primary CTA | Secondary CTA |
|------|-------------|---------------|
| / (homepage) | Apply for Custom Training | Get the Blueprint |
| /blueprint | Get Your Custom Program | Calculate Your Zones |
| /calculator | Apply for Custom Training | Get the Blueprint |
| /training (nav) | Apply for Custom Training | — |
| /training (hero) | Apply for Custom Training | Read the Blueprint First |
| /training (offer) | Apply Now | — |

**Application flow:**
1. User clicks CTA on /training
2. Modal opens with intake form
3. Fields: Name, Email, Training Background, Primary Goal, Days/Week, Additional Notes
4. Submit → inserted to `applications` table (Supabase, anon INSERT)
5. Coach reviews in /coach dashboard

---

## Revenue Model

- **Phase 1 (current):** Manual billing, <10 clients, Gumroad for Blueprint
- **Phase 2 (trigger: 10 clients):** Stripe recurring subscription ($199/month)
- **Phase 3 (future):** 8-week program added, potentially Stripe for all products
