# AT0M FIT — Brand Guide

---

## Color System

```css
:root {
  --bg:          #0B0B0B;                    /* Page background — near-black */
  --surface:     #111111;                    /* Cards, nav, modals */
  --surface2:    #1A1A1A;                    /* Nested cards, input fields */
  --border:      #2A2A2A;                    /* All borders and dividers */
  --gold:        #C9A04A;                    /* Primary accent — buttons, logo, highlights */
  --gold-bright: #D4AF37;                    /* Gold hover state */
  --gold-glow:   rgba(201, 160, 74, 0.25);  /* Focus rings, glows */
  --gold-dim:    rgba(201, 160, 74, 0.08);  /* Subtle tints */
  --text:        #F0EDE8;                    /* Primary text — warm white */
  --text-muted:  #888888;                    /* Labels, timestamps, secondary */
  --grey-light:  #B0B0B0;                    /* Supporting content */
  --grey-mid:    #6E6E6E;                    /* Tertiary labels */
  --error:       #e05555;                    /* Error states */
}
```

---

## Typography

### Fonts Required

```html
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
```

### Usage Rules

| Element | Font | Weight | Size | Style |
|---------|------|--------|------|-------|
| Logo / wordmark | Bebas Neue | — | 1.6–2.4rem | letter-spacing: 0.1em |
| Page headings | Bebas Neue | — | 2–4rem | letter-spacing: 0.04–0.06em |
| Section eyebrows | Inter | 700 | 0.70–0.78rem | uppercase, letter-spacing: 0.14–0.18em |
| Card titles | Bebas Neue | — | 1.2–1.6rem | letter-spacing: 0.05em |
| Body text | Inter | 400–500 | 0.88–1rem | normal |
| Button text | Inter | 700–800 | 0.85–0.95rem | uppercase, letter-spacing: 0.07em |
| Form labels | Inter | 700 | 0.72–0.78rem | uppercase, letter-spacing: 0.1em |
| Metadata / dates | Inter | 400–500 | 0.70–0.78rem | normal |

---

## Logo Treatment

```
AT0M FIT
```

- The zero "0" in AT0M is always rendered in gold: `<span style="color:var(--gold)">0</span>`
- Font: Bebas Neue
- Always on dark background — no white/light background version exists
- Never use a logo image file — it is always rendered as styled text

---

## Visual Rules

### Required
- Dark background on every page (`#0B0B0B`)
- Gold as the only accent color
- Card border-radius: 4px maximum
- Top gold border on featured cards: `border-top: 2px solid var(--gold)`
- All inputs: dark fill (`#1A1A1A`), border `#2A2A2A`, gold focus ring

### Prohibited
- Emojis in body copy, navigation, buttons, or headings
- Cyan, green, or blue accents (old legacy palette — removed May 2026)
- Rounded corners greater than 4px
- Gradients (except dark-to-transparent overlays on hero photos)
- White or light page backgrounds
- Generic "AI graphics" (glowing brains, robot arms, neon circuits)
- Stock photography with generic gym/fitness vibes
- Broken mockup text or placeholder graphics

---

## Tone & Brand Voice

- **Premium.** Never cheap or casual.
- **Tactical.** Precision and system. Results over motivation.
- **Masculine.** Direct, confident, not aggressive.
- **Clean.** No clutter. Whitespace is intentional.
- No exclamation points in body copy.
- No "Get started today!" language.
- CTAs are imperative but measured: "Apply for Custom Training" not "Sign Up Now!"

---

## Render Style (Social / Future Assets)

- Square (1:1) for posts, vertical (9:16) for stories
- Same dark palette — no white backgrounds
- Bebas Neue headlines, Inter supporting text
- Athlete photography: action shots, natural light, real effort
- Infographic color system: Blue=Z2, Yellow-green=Threshold, Orange=VO2, Red=Sprint, Green=Recovery

---

## Button Styles

```css
/* Primary CTA */
.btn-primary {
  background: var(--gold);
  color: #000;
  font-weight: 800;
  text-transform: uppercase;
  letter-spacing: 0.07em;
  border: none;
  border-radius: 4px;
  padding: 1rem 2rem;
}

.btn-primary:hover {
  background: var(--gold-bright);
  transform: translateY(-1px);
}

/* Secondary / outlined */
.btn-secondary {
  background: transparent;
  border: 1px solid var(--border);
  color: var(--text);
  /* same sizing as primary */
}
```
