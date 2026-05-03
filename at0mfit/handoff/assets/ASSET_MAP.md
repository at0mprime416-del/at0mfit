# AT0M FIT — Asset Map

---

## Location

All production assets are stored in the root of the `at0mfit/` folder alongside the HTML files.

**GitHub path:** `at0mfit/` (repo root, branch: `master`)  
**Vercel serves:** everything in the `at0mfit/` folder at the root domain

---

## Asset Inventory

| File | Size | Format | Used On | Description |
|------|------|--------|---------|-------------|
| `hero-banner.png` | 91KB | PNG | `/` | Homepage hero background/visual element |
| `athlete-sprint-front.png` | 646KB | PNG | `/training` | Full sprint athlete — training page hero |
| `athlete-run-steady.png` | 449KB | PNG | `/training` | Steady-state runner — Zone 2 section |
| `athlete-start.png` | 832KB | PNG | `/` | Athlete at starting position — homepage |
| `cover.png` | 2.3MB | PNG | `/blueprint` | Levi Cardio Blueprint ebook cover image |
| `author.jpg` | 68KB | JPG | `/blueprint` | Levi author photo |
| `heart-rate-zones.png` | 1.4MB | PNG | `/blueprint`, `/calculator` | Full 5-zone HR chart infographic |
| `aerobic-anaerobic.png` | 100KB | PNG | `/blueprint` | Aerobic vs anaerobic energy system diagram |
| `zone-chart.png` | 154KB | PNG | `/blueprint` | Zone chart — original version |
| `zone-chart-clean.png` | 26KB | PNG | `/blueprint`, `/calculator` | Zone chart — clean/simplified version |
| `gear-flatlay.png` | 976KB | PNG | `/blueprint`, `/` | Gear flatlay — watch, shoes, accessories |
| `shoes.png` | 877KB | PNG | `/blueprint` | Running shoes detail shot |
| `watch-metrics.png` | 890KB | PNG | `/`, `/portal` | Apple Watch showing training metrics |
| `watch-premium.png` | 1.1MB | PNG | `/portal` | Apple Watch premium UI view |
| `watch-setup.png` | 120KB | PNG | `/blueprint` | Apple Watch setup guide screenshot |

**Total:** 15 files, ~11MB

---

## How Assets Are Referenced in HTML

Direct relative path — no build pipeline, no asset hashing:

```html
<img src="./athlete-sprint-front.png" alt="..." />
<img src="./cover.png" alt="..." />
```

Because the HTML files are in the same folder as the assets, `./filename.png` works correctly.

---

## Missing Assets (Not Yet Created)

Do not create these without explicit instruction:

| Asset | Where Needed | Notes |
|-------|-------------|-------|
| Social media templates | Future campaigns | Quote cards, workout tips, program posts |
| Client avatar placeholder | coach.html (client cards) | Default when no photo uploaded |
| Coach dashboard favicon | All pages | Currently uses default browser favicon |
| Email header graphic | Client onboarding email | Needed when Resend email is built |
| 8-week program cover | Future product page | Needed when 8-week program is built |
| Progress photo placeholder | portal.html sidebar | Shown when client has no photos yet |

---

## Asset Guidelines for New Additions

When adding new image assets:

1. **Format:** PNG for graphics/diagrams. JPG for photography.
2. **Size:** Optimize before adding. Target <500KB for photos, <100KB for diagrams.
3. **Naming:** lowercase, hyphens, descriptive. E.g., `zone2-run-graphic.png`
4. **Location:** Drop in `at0mfit/` root alongside existing assets.
5. **Reference:** Use `./filename.png` in HTML `src` attributes.
6. **Alt text:** Always include descriptive alt text. Describe what the image shows.

---

## Mobile App Assets (Separate)

The mobile app (at0mfit-app/) uses assets differently:
- Avatar images: stored in Supabase Storage (not in repo)
- Progress photos: stored in Supabase Storage
- App icons: managed by Expo (app.json references)
- No large image files committed to at0mfit-app/ repo
