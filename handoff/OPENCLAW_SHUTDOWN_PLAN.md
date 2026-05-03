# AT0M FIT — OpenClaw Shutdown Plan

---

## Summary

OpenClaw completed the AT0M FIT build sprint. The project is packaged and handed off. OpenClaw is now in standby. This document defines exactly what happens next.

---

## Immediate Actions (Done)

| Action | Status |
|--------|--------|
| All AT0M FIT code committed and pushed to GitHub | ✅ Done |
| Dead cron jobs killed (doc_push, calendar_brief) | ✅ Done |
| Full handoff package created | ✅ Done |
| QCmd PASS on all gates | ✅ Done |

---

## What Can Be Paused Immediately

The following AT0M FIT OpenClaw operations stop now:

- All AT0M FIT code editing
- All AT0M FIT Supabase migrations
- All AT0M FIT QA testing
- All AT0M FIT build conversations

**AT0M FIT build work transfers entirely to Replit as of 2026-05-03.**

---

## What Stays Temporarily (Unrelated to AT0M FIT)

These OpenClaw automations are personal/multi-project utilities. They continue running until Levi explicitly stops them:

| Job | Continues? | Notes |
|-----|-----------|-------|
| Ezra (Google Sheets) | Yes | Book of Levi dashboard |
| Pulse (email routing) | Yes | Personal + business email dispatch |
| Deborah (ops reports) | Yes | All Levi Operations projects |

---

## What Should Be Archived

When Levi gives the hard shutdown instruction:

1. **Zip the workspace:**
   ```bash
   tar -czf at0mfit-openclaw-archive-$(date +%Y%m%d).tar.gz \
     /root/.openclaw/workspace/at0mfit/ \
     /root/.openclaw/workspace/at0mfit-app/ \
     /root/.openclaw/workspace/projects/at0mfit/
   ```

2. **Back up crontab:**
   ```bash
   crontab -l > ~/crontab-backup-$(date +%Y%m%d).txt
   ```

3. **Archive memory files** to cold storage or Google Drive

4. **Stop remaining crons** (only after Levi confirms Ezra/Pulse/Deborah are no longer needed)

5. **Shut down OpenClaw server** — VPS termination via hosting provider

---

## Hard Shutdown Trigger

OpenClaw shuts down for AT0M FIT when:

1. Replit successfully edits an AT0M FIT file and deploys to production ✅
2. Replit confirms /coach and /portal auth flows work ✅
3. Levi gives explicit: "Shut it down"

**AT0M does not self-terminate.** OpenClaw waits for explicit instruction.

---

## What Replit Does NOT Need From OpenClaw

- Session history or conversation logs
- Agent memory files (MEMORY.md) — personal context not relevant
- Personal automation scripts (Ezra/Pulse/Deborah)
- Any other Levi Operations project files

Everything Replit needs for AT0M FIT is in this handoff package.

---

## Replit Confirmation Checklist

Before OpenClaw shuts down, confirm Replit can:

- [ ] Import the GitHub repo (at0mprime416-del/at0mfit, branch: master)
- [ ] Set all secrets in Replit Secrets panel
- [ ] Edit one HTML file (e.g., add a word to index.html)
- [ ] Deploy to production via `vercel deploy --prod`
- [ ] Verify the change is live at at0mfit.com
- [ ] Log in to /portal as a test client
- [ ] Log in to /coach as jeshua@levioperations.com

When all 7 are checked: OpenClaw AT0M FIT operations are complete.

---

## Contact for Levi

If anything breaks post-handoff:

1. Check `KNOWN_BUGS_AND_RISKS.md` first
2. Check `DECISIONS_LOG.md` for context on why things were built a certain way
3. Check Supabase Dashboard → Logs for DB errors
4. Check Vercel Dashboard → Deployments for deploy errors
5. If needed: reactivate OpenClaw session and ask AT0M directly

---

*OpenClaw standing by. AT0M FIT build: complete.*
