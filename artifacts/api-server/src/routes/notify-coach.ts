import { Router } from "express";
import nodemailer from "nodemailer";

const router = Router();

const DEFAULT_NOTIFY_TO = "jeshua@levioperations.com";

router.post("/notify-coach", async (req, res) => {
  try {
    const {
      type = "Event",
      client_name = "Unknown Client",
      client_email = "",
      subject,
      summary = "",
      metadata = {},
    } = req.body;

    const gmailUser = process.env.GMAIL_USER;
    const gmailPass = process.env.GMAIL_APP_PASSWORD;
    const notifyTo = process.env.NOTIFICATION_TO_EMAIL || DEFAULT_NOTIFY_TO;

    if (!gmailUser || !gmailPass) {
      req.log.warn(
        "Email notification skipped — Gmail secrets missing. Set GMAIL_USER and GMAIL_APP_PASSWORD."
      );
      res.json({ ok: true, skipped: true, reason: "Gmail secrets missing" });
      return;
    }

    const emailSubject = subject || `New AT0M FIT ${type}`;
    const timestamp = new Date().toLocaleString("en-US", {
      timeZone: "America/Chicago",
      month: "short",
      day: "numeric",
      year: "numeric",
      hour: "numeric",
      minute: "2-digit",
    });

    const metaRows = Object.entries(metadata)
      .map(([k, v]) => `<tr><td style="color:#888;padding:4px 0;font-size:13px;text-transform:capitalize">${k.replace(/_/g," ")}</td><td style="color:#f0ede8;padding:4px 0 4px 16px;font-size:13px">${v}</td></tr>`)
      .join("");

    const html = `<!DOCTYPE html>
<html>
<head><meta charset="utf-8"></head>
<body style="background:#0b0b0b;color:#f0ede8;font-family:Arial,sans-serif;margin:0;padding:0">
  <div style="max-width:600px;margin:0 auto;padding:40px 24px">
    <div style="font-size:28px;font-weight:900;letter-spacing:4px;margin-bottom:8px">AT<span style="color:#C9A04A">0</span>M FIT</div>
    <div style="font-size:11px;color:#C9A04A;font-weight:700;letter-spacing:2px;text-transform:uppercase;margin-bottom:32px">Coach Notification</div>

    <div style="background:#111;border:1px solid #2a2a2a;border-top:2px solid #C9A04A;border-radius:4px;padding:24px;margin-bottom:24px">
      <div style="font-size:11px;color:#C9A04A;font-weight:700;letter-spacing:2px;text-transform:uppercase;margin-bottom:6px">${type}</div>
      <div style="font-size:22px;font-weight:900;margin-bottom:4px">${client_name}</div>
      ${client_email ? `<div style="color:#888;font-size:13px;margin-bottom:16px">${client_email}</div>` : ""}
      ${summary ? `<div style="color:#b0b0b0;font-size:14px;line-height:1.6;margin-bottom:16px">${summary}</div>` : ""}
      ${metaRows ? `<table style="width:100%;border-top:1px solid #2a2a2a;margin-top:12px;padding-top:12px">${metaRows}</table>` : ""}
    </div>

    <div style="font-size:12px;color:#444;margin-bottom:16px">Submitted: ${timestamp}</div>

    <div style="background:#111;border:1px solid #2a2a2a;border-radius:4px;padding:16px;font-size:13px;color:#888">
      Go to <strong style="color:#C9A04A">/coach</strong> to view and respond.
    </div>

    <div style="margin-top:32px;font-size:11px;color:#333">
      AT0M FIT &copy; 2026 &middot; Automated coach notification
    </div>
  </div>
</body>
</html>`;

    const transporter = nodemailer.createTransport({
      host: "smtp.gmail.com",
      port: 587,
      secure: false,
      auth: { user: gmailUser, pass: gmailPass },
    });

    await transporter.sendMail({
      from: `"AT0M FIT" <${gmailUser}>`,
      replyTo: gmailUser,
      to: notifyTo,
      subject: emailSubject,
      html,
    });

    res.json({ ok: true });
  } catch (err) {
    req.log.error({ err }, "notify-coach error");
    res.status(500).json({ error: "Notification failed" });
  }
});

export default router;
