# AT0M FIT — Legal Pages Status

**Last updated:** 2026-05-03

---

## Pages Created

| Page | Route | Status | Notes |
|------|-------|--------|-------|
| Terms of Service | `/terms` | DRAFT — Needs legal review | Draft banner displayed on page |
| Privacy Policy | `/privacy` | DRAFT — Needs legal review | Draft banner displayed on page |
| Training Waiver | `/waiver` | DRAFT — Needs legal review | Draft banner displayed on page |
| Support | `/support` | LIVE — Functional | Form submits to Supabase + notifies coach |

All legal pages are live in the Vite dev and production servers. Draft pages display a visible banner: "Draft — Pending Owner and Legal Review."

---

## What Needs Owner Action Before Going Live

### Terms of Service (/terms)
- Fill in: Governing law and jurisdiction
- Fill in: Payment and refund terms (subscription tiers, billing cycles, cancellation policy)
- Fill in: Contact email address for legal inquiries
- Remove: Draft banner once approved
- Action: Have qualified legal counsel review and approve

### Privacy Policy (/privacy)
- Fill in: Contact email for privacy requests
- Fill in: Cookie policy details
- Fill in: Data retention timeframes
- Determine: GDPR compliance needs (if EU users)
- Determine: CCPA compliance needs (if California users)
- Remove: Draft banner once approved
- Action: Have qualified legal counsel review and approve

### Training Waiver (/waiver)
- Add: Formal release of liability language (requires attorney)
- Add: Acceptance mechanism (checkbox or digital signature at registration)
- Remove: Draft banner once approved
- Action: PRIORITY — Have an attorney specializing in fitness/sports law draft the final version

---

## Integration Points

- **Portal /portal**: Help tab and Account tab link to `/terms`, `/privacy`, `/waiver`
- **Portal footer**: Links to Terms, Privacy, Support
- **Support /support**: Footer links to all legal pages
- **terms.html footer**: Links to Privacy, Waiver, Support
- **privacy.html footer**: Links to Terms, Waiver, Support
- **waiver.html footer**: Links to Terms, Privacy, Support

---

## Future: Legal Acceptance Tracking

`FINAL_HARDENING_SETUP.sql` creates a `legal_acceptances` table that can log when clients accept terms during registration. Implement this at the registration flow once legal documents are finalized.

---

## Status Summary

- LEGAL_PAGES_CREATED: YES
- LEGAL_PAGES_LINKED: YES
- LEGAL_REVIEW_COMPLETE: NO — PENDING OWNER
- LEGAL_PAGES_IN_EFFECT: NO — Draft only
