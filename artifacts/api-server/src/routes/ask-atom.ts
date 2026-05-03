import { Router } from "express";

const router = Router();

const SAFETY_KEYWORDS = [
  "chest pain", "fainting", "fainted", "dizziness", "dizzy",
  "medication", "prescription", "diagnosis", "injury", "broken",
  "eating disorder", "anorexia", "bulimia", "starvation", "cutting weight fast",
  "supplement", "steroid", "dangerous", "emergency"
];

const SYSTEM_PROMPT = `You are AT0M, a no-nonsense elite performance coach assistant for AT0M FIT.
Your role: give short, direct, motivating answers to training and lifestyle questions.

Rules you must follow absolutely:
- No medical diagnosis, injury treatment, or medication advice. Refer to a doctor.
- No extreme dieting, dangerous dehydration, or cutting advice.
- No supplement claims or endorsements.
- No eating disorder advice — refer to a medical professional and the coach immediately.
- If the user mentions chest pain, fainting, dizziness, or any medical emergency: STOP. Tell them to seek emergency help immediately.
- Keep answers to 1-3 sentences + next steps.
- End with one short line of encouragement.
- Be direct, be tactical, be honest. No fluff.`;

function checkSafety(text: string): { flagged: boolean; reason: string } {
  const lower = text.toLowerCase();
  for (const kw of SAFETY_KEYWORDS) {
    if (lower.includes(kw)) {
      return { flagged: true, reason: `Contains keyword: "${kw}"` };
    }
  }
  return { flagged: false, reason: "" };
}

const FALLBACK_RESPONSES: Record<string, string> = {
  default: "Your question was saved. Your coach will review it in your next session. Keep training.",
  sleep: "Prioritize 7-9 hours. Sleep is your performance multiplier — no supplement replaces it.",
  nutrition: "Nail your protein first. 0.8-1g per pound of bodyweight. Everything else follows.",
  zone2: "Zone 2 means you can hold a conversation. If you can't talk, slow down. Build the base before intensity.",
  recovery: "Recovery is training. Active recovery, sleep, and nutrition are your tools. Use them.",
};

router.post("/ask-atom", async (req, res) => {
  const {
    question = "",
    client_id = null,
    client_email = "",
    client_name = "Athlete",
  } = req.body;

  if (!question.trim()) {
    res.status(400).json({ error: "Question is required." });
    return;
  }

  const { flagged, reason } = checkSafety(question);

  // Safety hard-stop for emergencies
  if (flagged && reason.includes("chest pain") || reason.includes("fainting") || reason.includes("emergency")) {
    const safetyAnswer = "STOP TRAINING IMMEDIATELY. If you are experiencing chest pain, fainting, or a medical emergency — call 911 or go to an emergency room now. This is not something a coach can help with. Seek emergency medical attention.";
    await logToSupabase(client_id, client_email, question, safetyAnswer, true, reason, req);
    res.json({ answer: safetyAnswer, flagged: true });
    return;
  }

  const apiKey = process.env.OPENAI_API_KEY;

  if (!apiKey) {
    req.log.warn("Ask AT0M skipped — OPENAI_API_KEY missing. Question saved for coach review.");
    await logToSupabase(client_id, client_email, question, null, flagged, reason, req);

    // Pick a contextual fallback
    const lower = question.toLowerCase();
    let answer = FALLBACK_RESPONSES.default;
    if (lower.includes("sleep")) answer = FALLBACK_RESPONSES.sleep;
    else if (lower.includes("nutrition") || lower.includes("eat") || lower.includes("food") || lower.includes("protein")) answer = FALLBACK_RESPONSES.nutrition;
    else if (lower.includes("zone 2") || lower.includes("zone2") || lower.includes("cardio")) answer = FALLBACK_RESPONSES.zone2;
    else if (lower.includes("recover") || lower.includes("sore") || lower.includes("rest")) answer = FALLBACK_RESPONSES.recovery;

    res.json({
      answer,
      flagged,
      saved: true,
      notice: "Ask AT0M is not fully configured yet. Your question was saved for coach review."
    });
    return;
  }

  try {
    const OpenAI = (await import("openai")).default;
    const client = new OpenAI({ apiKey });

    const completion = await client.chat.completions.create({
      model: "gpt-4o-mini",
      max_tokens: 300,
      messages: [
        { role: "system", content: SYSTEM_PROMPT },
        { role: "user", content: question }
      ]
    });

    const answer = completion.choices[0]?.message?.content || FALLBACK_RESPONSES.default;
    const tokens = completion.usage?.total_tokens;

    await logToSupabase(client_id, client_email, question, answer, flagged, reason, req, "gpt-4o-mini", tokens);

    res.json({ answer, flagged, tokens });
  } catch (err: any) {
    req.log.error({ err }, "Ask AT0M OpenAI error");
    await logToSupabase(client_id, client_email, question, null, flagged, reason, req);
    res.json({
      answer: "Ask AT0M is temporarily unavailable. Your question was saved — your coach will address it.",
      flagged,
      saved: true
    });
  }
});

async function logToSupabase(
  clientId: string | null,
  clientEmail: string,
  question: string,
  answer: string | null,
  flagged: boolean,
  flagReason: string,
  req: any,
  model?: string,
  tokens?: number
) {
  try {
    const url = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL;
    const key = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.VITE_SUPABASE_ANON_KEY;
    if (!url || !key) return;

    const { createClient } = await import("@supabase/supabase-js");
    const sb = createClient(url, key);

    await sb.from("ask_atom_logs").insert([{
      client_id: clientId || null,
      client_email: clientEmail || null,
      question,
      answer,
      is_flagged: flagged,
      flag_reason: flagReason || null,
      model_used: model || null,
      tokens_used: tokens || null
    }]);
  } catch (e) {
    req.log?.warn("Could not log ask_atom to Supabase — table may not exist yet.");
  }
}

export default router;
