# AT0M FIT — Automation Migration Plan

---

## Current OpenClaw Cron Jobs

| Job | Schedule | Function | AT0M FIT? | Decision |
|-----|----------|----------|-----------|----------|
| Ezra | Every 2h | Scans project files → updates Google Sheet | No | Keep on OpenClaw |
| Pulse | Every 3h | Reads Gmail → routes emails to dispatch files | No | Keep on OpenClaw |
| Deborah | Every 6h | Sends ops status email report | No | Keep on OpenClaw |
| Doc Push | Every 6h | Pushes markdown to Google Docs | No | **KILLED 2026-05-03** |
| Calendar Brief | Daily 12:00 UTC | Daily calendar summary | No | **KILLED 2026-05-03** (file was missing) |

**Result:** Zero AT0M FIT-specific automations exist on OpenClaw. All five crons were personal/multi-project utilities.

---

## Kill List (Already Done)

```bash
# Removed from crontab 2026-05-03:
# 0 */6 * * * python3 .../doc_push.py          ← low value
# 0 12  * * * python3 .../calendar_brief.py     ← file missing (paused/)
```

---

## Keep List (Not AT0M FIT — Leave Alone)

| Job | Reason to Keep |
|-----|---------------|
| Ezra | Book of Levi Google Sheet sync — Levi's personal dashboard |
| Pulse | Email routing for Levi's personal and business inboxes |
| Deborah | Ops status reports for all Levi Operations projects |

These run on OpenClaw server. They are not related to AT0M FIT. Do not kill without Levi's instruction.

---

## AT0M FIT Automations That Should Exist

None of these are built yet. Listed in recommended build order:

### 1. New Application → Coach Email Notification
**When:** New row inserted to `applications` table  
**What:** Email to jeshua@levioperations.com — "New application from [name], goal: [goal]"  
**Platform:** Supabase Webhook → Resend  
**Complexity:** Low (Supabase has native webhook support)  
**Build when:** Before first 5 applications

### 2. Weekly Check-in Summary
**When:** Every Monday morning (ET)  
**What:** Email to coach — list of clients who submitted / did not submit check-ins this week  
**Platform:** GitHub Actions (cron) or Supabase pg_cron  
**Complexity:** Low  
**Build when:** After first 3 clients active

### 3. Client Inactivity Alert
**When:** If no workout log or check-in in 10 days  
**What:** Email to coach — "[Client name] hasn't checked in in 10 days"  
**Platform:** Supabase pg_cron or GitHub Actions  
**Complexity:** Low-medium  
**Build when:** After first 5 clients active

### 4. Broken Link Checker
**When:** Weekly  
**What:** Crawl at0mfit.com, report any 4xx/5xx routes  
**Platform:** GitHub Actions (free, runs on schedule)  
**Complexity:** Low  
**Build when:** Anytime — low priority

### 5. Sales / Lead Summary
**When:** Weekly  
**What:** Count new applications, waitlist signups, and Blueprint sales (Gumroad API)  
**Platform:** GitHub Actions  
**Complexity:** Medium (Gumroad API access needed)  
**Build when:** After 10+ applications

---

## What Replit Should Run (Eventually)

Replit is NOT a cron platform. For scheduled automations, use:
- **Supabase webhooks** (event-driven, instant, free)
- **GitHub Actions** (time-based, free tier = 2,000 min/month)
- **Supabase pg_cron** (SQL-level scheduled jobs)

**Do not build automation loops in Replit itself.** Replit is the build environment, not the runtime host.

---

## What Should Stay Manual

| Task | Why Manual |
|------|-----------|
| Client account creation | Founding phase — <10 clients, 5 minutes per client |
| Monthly billing | No Stripe yet — Venmo/PayPal/Zelle manual |
| Application approval | Judgment call — coach reviews each one |
| Workout program design | Core coaching work — cannot be automated |

---

## Recommended First Automation (Build Now)

**New Application → Notify Coach (Supabase Webhook → Resend)**

```
Supabase Dashboard → Database → Webhooks → New webhook
  Table: applications
  Event: INSERT
  URL: [Resend API endpoint or Vercel function]
  Payload: {full_name, email, primary_goal, days_per_week, submitted_at}

Endpoint action: POST to Resend API
  To: jeshua@levioperations.com
  Subject: New AT0M FIT Application — [name]
  Body: Name, email, goal, days/week, timestamp
```

This requires no polling, no cron, no Replit runtime — just a Supabase webhook + one API call.
