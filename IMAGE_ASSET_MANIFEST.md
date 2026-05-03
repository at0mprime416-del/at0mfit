# AT0M FIT — Image Asset Manifest

**Generated:** 2026-05-03
**Status:** COMPLETE — All images moved to `/assets/` subfolder

---

## Asset Folder Location

```
artifacts/at0mfit-web/public/assets/
```

All static image files are stored here. HTML references use `./assets/filename.ext` (relative path — safe with any Vite base path).

---

## Inventory

| Filename | Type | Used In | Purpose |
|----------|------|---------|---------|
| `aerobic-anaerobic.png` | PNG | blueprint.html | Aerobic vs anaerobic energy systems chart |
| `athlete-run-steady.png` | PNG | blueprint.html, training.html | Steady-state running athlete photo |
| `athlete-sprint-front.png` | PNG | blueprint.html, training.html | Sprint front-view athlete photo |
| `athlete-start.png` | PNG | training.html | Starting position athlete photo |
| `author.jpg` | JPG | blueprint.html | Author/coach portrait |
| `cover.png` | PNG | General | Cover/hero image |
| `gear-flatlay.png` | PNG | General | Gear flatlay product shot |
| `heart-rate-zones.png` | PNG | blueprint.html | Heart rate zone chart |
| `hero-banner.png` | PNG | General | Homepage hero banner |
| `opengraph.jpg` | JPG | Social meta | Open Graph social share image |
| `shoes.png` | PNG | General | Running shoes product shot |
| `watch-metrics.png` | PNG | General | Watch displaying metrics |
| `watch-premium.png` | PNG | blueprint.html | Premium watch display |
| `watch-setup.png` | PNG | blueprint.html | Watch setup/pairing screen |
| `zone-chart-clean.png` | PNG | General | Clean version zone chart |
| `zone-chart.png` | PNG | General | Zone training chart |

**Total assets: 16 files**

---

## Reference Pattern

All HTML files use relative paths:
```html
<img src="./assets/filename.png" onerror="this.style.display='none'" />
```

CSS background images:
```css
background-image: url('./assets/filename.png');
```

Dynamic Supabase storage URLs (portal/coach/community progress photos) are absolute URLs from Supabase — no change needed.

---

## Adding New Assets

1. Place the file in `artifacts/at0mfit-web/public/assets/`
2. Reference as `./assets/yourfile.ext` in HTML
3. Add an `onerror` handler on all `<img>` tags
4. Update this manifest

---

## Notes

- Do NOT use absolute paths (`/assets/...`) — they will break with Vite base path prefix
- Do NOT reference `./filename.ext` directly from document root for images — use `./assets/filename.ext`
- Supabase progress photo URLs are dynamic and use full https:// URLs — leave those unchanged
