import { Router } from "express";
import nodemailer from "nodemailer";

const router = Router();

const HTML_BODY = `<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <style>
    body { background: #0a0a0a; color: #ffffff; font-family: Arial, sans-serif; margin: 0; padding: 0; }
    .container { max-width: 600px; margin: 0 auto; padding: 40px 24px; }
    .logo { font-size: 32px; font-weight: 900; letter-spacing: 4px; color: #ffffff; margin-bottom: 32px; }
    .logo span { color: #C9A84C; }
    .hero { font-size: 28px; font-weight: 900; letter-spacing: 2px; margin-bottom: 16px; }
    .sub { font-size: 16px; color: #888888; line-height: 1.6; margin-bottom: 32px; }
    .badge { display: inline-block; background: rgba(201,168,76,0.12); border: 1px solid #C9A84C; color: #C9A84C; font-size: 12px; font-weight: 700; letter-spacing: 2px; padding: 8px 16px; border-radius: 20px; margin-bottom: 32px; }
    .divider { border: none; border-top: 1px solid #222; margin: 32px 0; }
    .what-next { font-size: 13px; color: #888; line-height: 1.8; }
    .footer { margin-top: 48px; font-size: 11px; color: #444; }
  </style>
</head>
<body>
  <div class="container">
    <div class="logo">AT<span>0</span>M FIT</div>
    <div class="badge">&#9889; EARLY ACCESS CONFIRMED</div>
    <div class="hero">YOU&#39;RE ON THE LIST.</div>
    <p class="sub">
      We got you. When At0m Fit opens for early access, you&#39;ll be first in line.<br><br>
      This isn&#39;t another fitness app. It&#39;s an AI coach that actually knows your history &mdash; your lifts, your runs, your sleep, your nutrition &mdash; and prescribes your next move based on all of it.
    </p>
    <hr class="divider">
    <p class="what-next">
      <strong style="color:#ffffff;">What happens next:</strong><br>
      &rarr; We&#39;re finishing the final QC pass on the app<br>
      &rarr; Early access users get in before public launch<br>
      &rarr; You&#39;ll get a direct link to download when it&#39;s ready<br><br>
      In the meantime &mdash; follow the build at at0mfit.com
    </p>
    <div class="footer">
      At0m Fit &copy; 2026 &middot; You&#39;re receiving this because you joined the waitlist at at0mfit.com
    </div>
  </div>
</body>
</html>`;

router.post("/waitlist-confirm", async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) {
      res.status(400).json({ error: "No email" });
      return;
    }

    const gmailUser = process.env.GMAIL_USER;
    const gmailPass = process.env.GMAIL_APP_PASSWORD;

    if (!gmailUser || !gmailPass) {
      req.log.warn("GMAIL_USER or GMAIL_APP_PASSWORD not set — skipping confirmation email");
      res.json({ ok: true, skipped: true });
      return;
    }

    const transporter = nodemailer.createTransport({
      host: "smtp.gmail.com",
      port: 587,
      secure: false,
      auth: {
        user: gmailUser,
        pass: gmailPass,
      },
    });

    await transporter.sendMail({
      from: `"At0m Fit" <${gmailUser}>`,
      replyTo: gmailUser,
      to: email,
      subject: "You're in. Welcome to At0m Fit. ⚛️",
      html: HTML_BODY,
    });

    res.json({ ok: true });
  } catch (err) {
    req.log.error({ err }, "waitlist-confirm error");
    res.status(500).json({ error: "Mail failed" });
  }
});

export default router;
