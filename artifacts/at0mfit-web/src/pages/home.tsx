import { useState } from 'react'
import { supabase, isSupabaseConfigured } from '@/lib/supabase'

const FEATURES = [
  {
    icon: '⚡',
    title: 'AI COACH',
    desc: 'Personalized workouts built from your history. Progressive overload, carb cycling, sleep optimization. Adapts weekly based on your actual data.',
    badge: 'PRO',
    stat: 'Fully adaptive',
  },
  {
    icon: '💪',
    title: 'WORKOUT TRACKER',
    desc: 'Set-by-set logging with rest timers, 1RM calculator, and previous performance shown inline. Notes per exercise. 100+ movements.',
    badge: null,
    stat: '100+ exercises',
  },
  {
    icon: '📊',
    title: 'PROGRESS ANALYTICS',
    desc: "Body weight trend, personal records, training volume over time. Toggle 7D / 30D / 90D ranges. See exactly where you're winning.",
    badge: null,
    stat: '3 time ranges',
  },
  {
    icon: '🏆',
    title: 'COMPETE',
    desc: 'Wall Street-style leaderboard. AT0M INDEX. Teams. Futures contracts. Token rewards. Real-time live updates.',
    badge: null,
    stat: 'Live rankings',
  },
  {
    icon: '🏃',
    title: 'LIVE RUN TRACKING',
    desc: 'GPS route on Google Maps, real-time pace, distance, and duration. Mileage charts over time. Every mile logged.',
    badge: null,
    stat: 'GPS powered',
  },
  {
    icon: '🥗',
    title: 'NUTRITION + SLEEP',
    desc: 'Meal logging with macros, supplement tracker, and sleep quality tracking. All feeds the AI coach so it accounts for your recovery.',
    badge: null,
    stat: 'Feeds the AI',
  },
  {
    icon: '📷',
    title: 'FORM CHECK',
    desc: 'Record your lifts directly in-app. Review form with full camera playback. Progress photo grid with before/after comparison.',
    badge: null,
    stat: 'In-app camera',
  },
  {
    icon: '🗓️',
    title: 'CALENDAR',
    desc: 'Full training history. Every workout, run, and meal in one timeline. Look back at any day and see exactly what you did.',
    badge: null,
    stat: 'Full history',
  },
]

const FREE_FEATURES = [
  'Workout logging (unlimited sets)',
  'Run tracking with GPS',
  'Progress photos & form check',
  'Basic leaderboard & compete',
  'Nutrition & meal logging',
  'Calendar history',
  'Training streak tracking',
]

const PRO_FEATURES = [
  'Everything in Free',
  '⚡ AI Daily Brief — full training + nutrition + sleep prescription',
  '⚡ AI Workout Generator — adaptive program from your history',
  '⚡ Carb cycling protocol (high/low/moderate days)',
  '⚡ Intermittent fasting window recommendations',
  '⚡ Sleep optimization targets',
  '⚡ Progressive overload auto-calculated',
  '⚡ Weekly program adaptation',
]

const PERSONAS = [
  {
    emoji: '🪖',
    title: 'The Operator',
    desc: 'You need performance, not a hobby. AI Coach prescribes your program around your shifts, recovery, and physical standards.',
  },
  {
    emoji: '🏋️',
    title: 'The Lifter',
    desc: 'Every PR tracked. 1RM auto-calculated. Progressively overloaded each session. Form checks recorded. Nothing guessed.',
  },
  {
    emoji: '🏃',
    title: 'The Runner',
    desc: 'Live GPS tracking, pace analytics, mileage charts. Every run in your calendar. Training load balanced against lifting days.',
  },
  {
    emoji: '📈',
    title: 'The Competitor',
    desc: 'You want to know where you stand. The Wall Street leaderboard runs 24/7. Earn tokens. Build a team. Move the index.',
  },
]

export default function Home() {
  const [email, setEmail] = useState('')
  const [status, setStatus] = useState<'idle' | 'loading' | 'success' | 'duplicate' | 'error'>('idle')

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!email || status === 'loading' || status === 'success') return
    setStatus('loading')
    try {
      if (!isSupabaseConfigured || !supabase) {
        setStatus('error')
        return
      }
      const { error } = await supabase.from('waitlist').insert({ email })
      if (!error) {
        fetch('/api/waitlist-confirm', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ email }),
        }).catch(() => {})
        fetch('/api/notify-coach', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            type: 'New Waitlist Signup',
            client_name: email.split('@')[0],
            client_email: email,
            subject: 'New AT0M FIT Waitlist Signup',
            summary: `${email} joined the AT0M FIT waitlist.`,
            metadata: { email }
          })
        }).catch(() => {})
        setStatus('success')
      } else if (error.code === '23505') {
        setStatus('duplicate')
      } else {
        console.error('Waitlist error:', error)
        setStatus('error')
      }
    } catch (err) {
      console.error('Waitlist exception:', err)
      setStatus('error')
    }
  }

  const buttonLabel = () => {
    if (status === 'loading') return 'JOINING...'
    if (status === 'success') return "✓ You're in!"
    return 'GET ACCESS'
  }

  const buttonClass = () => {
    const base = 'px-6 py-3.5 font-bold text-sm tracking-widest uppercase rounded-xl whitespace-nowrap transition-all duration-200'
    if (status === 'success') return `${base} bg-[#39ff14] text-black cursor-default`
    if (status === 'loading') return `${base} bg-[#C9A84C] text-black opacity-60 cursor-not-allowed`
    return `${base} bg-[#C9A84C] text-black hover:shadow-[0_0_20px_rgba(201,168,76,0.4)] hover:-translate-y-px`
  }

  const statusMessage = () => {
    if (status === 'duplicate') return <p className="text-sm text-[#C9A84C] mt-3">You&apos;re already on the list 👊</p>
    if (status === 'error') return <p className="text-sm text-red-400 mt-3">Something went wrong. Try again.</p>
    return null
  }

  return (
    <main className="min-h-screen bg-[#0a0a0a] text-white">

      {/* ── NAV ── */}
      <nav className="fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-6 py-4 bg-[#0a0a0a]/90 backdrop-blur-md border-b border-[#222]">
        <span
          className="text-3xl tracking-wider text-white"
          style={{ fontFamily: "'Bebas Neue', sans-serif" }}
        >
          AT<span className="text-[#C9A84C]">0</span>M FIT
        </span>
        <div className="flex items-center gap-4">
          <a href="#features" className="hidden sm:block text-xs font-semibold tracking-widest uppercase text-[#888] hover:text-[#C9A84C] transition-colors">Features</a>
          <a href="#compete" className="hidden sm:block text-xs font-semibold tracking-widest uppercase text-[#888] hover:text-[#C9A84C] transition-colors">Compete</a>
          <a
            href="#waitlist"
            className="px-5 py-2 bg-[#C9A84C] text-black font-bold text-sm tracking-widest uppercase rounded-lg hover:shadow-[0_0_20px_rgba(201,168,76,0.4)] transition-all duration-200 hover:-translate-y-px"
          >
            Join Waitlist
          </a>
        </div>
      </nav>

      {/* ── HERO ── */}
      <section className="relative min-h-screen flex flex-col items-center justify-center text-center px-6 pt-28 pb-20 overflow-hidden">
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-[900px] h-[900px] bg-[radial-gradient(circle,rgba(201,168,76,0.08)_0%,transparent_60%)] pointer-events-none" />

        <div className="inline-flex items-center gap-2 bg-[rgba(201,168,76,0.08)] border border-[rgba(201,168,76,0.3)] text-[#C9A84C] text-xs font-semibold tracking-widest uppercase px-4 py-2 rounded-full mb-8">
          <span className="w-1.5 h-1.5 bg-[#C9A84C] rounded-full animate-pulse" />
          Beta — limited access open
        </div>

        <h1
          className="text-[clamp(4rem,12vw,9rem)] leading-none tracking-wide mb-6"
          style={{
            fontFamily: "'Bebas Neue', sans-serif",
            background: 'linear-gradient(180deg, #ffffff 0%, #aaaaaa 100%)',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            backgroundClip: 'text',
          }}
        >
          TRAIN LIKE AN
          <br />
          <span
            style={{
              background: 'linear-gradient(135deg, #C9A84C 0%, #e0c06a 100%)',
              WebkitBackgroundClip: 'text',
              WebkitTextFillColor: 'transparent',
              backgroundClip: 'text',
            }}
          >
            OPERATOR
          </span>
        </h1>

        <p className="max-w-xl text-lg text-[#888] leading-relaxed mb-4">
          Your AI coach knows your history. Prescribes workouts, nutrition, and recovery —{' '}
          <strong className="text-white">then adapts as you improve.</strong>
        </p>

        <p className="text-sm text-[#555] mb-10">
          Built for operators, athletes, and anyone who trains with intention.
        </p>

        <div className="flex flex-wrap gap-4 justify-center mb-16">
          <a
            href="#waitlist"
            className="relative inline-flex items-center gap-2 px-8 py-4 bg-[#C9A84C] text-black font-extrabold text-base tracking-widest uppercase rounded-xl hover:-translate-y-1 hover:shadow-[0_8px_30px_rgba(201,168,76,0.4)] transition-all duration-200"
          >
            Get Early Access
          </a>
          <a
            href="#features"
            className="inline-flex items-center gap-2 px-8 py-4 bg-transparent text-white font-bold text-base tracking-widest uppercase rounded-xl border border-[#333] hover:border-[#00d4ff] hover:text-[#00d4ff] transition-all duration-200"
          >
            See the App ↓
          </a>
        </div>

        <div className="flex flex-wrap gap-10 justify-center">
          {[
            { num: '8', label: 'Core Screens' },
            { num: '100+', label: 'Exercises' },
            { num: 'AI', label: 'Powered Coach' },
            { num: 'GPS', label: 'Run Tracking' },
          ].map(({ num, label }) => (
            <div key={label} className="text-center">
              <div
                className="text-4xl text-[#C9A84C] tracking-wide"
                style={{ fontFamily: "'Bebas Neue', sans-serif" }}
              >
                {num}
              </div>
              <div className="text-xs text-[#888] uppercase tracking-widest mt-1">{label}</div>
            </div>
          ))}
        </div>
      </section>

      {/* ── WHO IT'S FOR ── */}
      <section className="bg-[#111] py-20 px-6 border-t border-[#222]">
        <div className="max-w-5xl mx-auto">
          <div className="text-center mb-12">
            <p className="text-xs font-semibold tracking-[0.15em] uppercase text-[#C9A84C] mb-3">Who It&apos;s For</p>
            <h2
              className="text-[clamp(2rem,5vw,3.5rem)] leading-none tracking-wide"
              style={{ fontFamily: "'Bebas Neue', sans-serif" }}
            >
              BUILT FOR PEOPLE WHO
              <br />
              <span className="text-[#C9A84C]">ACTUALLY TRAIN.</span>
            </h2>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
            {PERSONAS.map(({ emoji, title, desc }) => (
              <div
                key={title}
                className="bg-[#0a0a0a] border border-[#222] rounded-2xl p-7 hover:border-[rgba(201,168,76,0.3)] hover:-translate-y-1 transition-all duration-300"
              >
                <div className="text-3xl mb-4">{emoji}</div>
                <h3
                  className="text-xl tracking-wide text-[#C9A84C] mb-2"
                  style={{ fontFamily: "'Bebas Neue', sans-serif" }}
                >
                  {title}
                </h3>
                <p className="text-[#888] text-sm leading-relaxed">{desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── COMPETE SPOTLIGHT ── */}
      <section id="compete" className="bg-[#0a0a0a] py-20 px-6 border-t border-[#222]">
        <div className="max-w-5xl mx-auto">
          <div className="bg-[#111] border border-[#C9A84C] rounded-2xl p-10 md:p-14 relative overflow-hidden">
            <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-[radial-gradient(circle,rgba(201,168,76,0.06)_0%,transparent_70%)] pointer-events-none" />

            <div className="relative">
              <div className="inline-flex items-center gap-3 bg-[rgba(201,168,76,0.10)] border border-[rgba(201,168,76,0.3)] px-4 py-2 rounded mb-6">
                <span className="text-[#C9A84C] text-xs font-mono font-bold tracking-[0.2em]">AT0M INDEX ↑ LIVE</span>
                <span className="w-1.5 h-1.5 bg-[#39ff14] rounded-full animate-pulse" />
              </div>

              <h2
                className="text-[clamp(2rem,5vw,4rem)] leading-none tracking-wide mb-4"
                style={{ fontFamily: "'Bebas Neue', sans-serif" }}
              >
                THE LEADERBOARD LOOKS
                <br />
                <span className="text-[#C9A84C]">LIKE A TRADING FLOOR.</span>
              </h2>

              <p className="text-[#888] text-lg leading-relaxed max-w-2xl mb-8">
                Because competition should feel like high stakes. The Compete screen is a Wall Street-style fitness exchange — AT0M INDEX tracking platform activity, teams with market cap rankings, futures contracts, real-time token updates, and live countdowns. This is not a step counter.
              </p>

              <div className="grid grid-cols-1 sm:grid-cols-3 gap-6 mb-8">
                {[
                  { label: 'AT0M INDEX', value: '1,247', change: '↑ LIVE', color: '#C9A84C' },
                  { label: 'MARKETS OPEN', value: '14:32:07', change: 'UNTIL CLOSE', color: '#00d4ff' },
                  { label: 'TOP TOKENS', value: '⚛ 8,420', change: '▲ GAINERS', color: '#39ff14' },
                ].map(({ label, value, change, color }) => (
                  <div key={label} className="bg-[#0a0a0a] border border-[#222] rounded-xl p-5 font-mono">
                    <div className="text-xs text-[#555] tracking-widest mb-2">{label}</div>
                    <div className="text-2xl font-bold mb-1" style={{ color }}>{value}</div>
                    <div className="text-xs" style={{ color }}>{change}</div>
                  </div>
                ))}
              </div>

              <div className="flex flex-wrap gap-5">
                {['Global leaderboard', 'Team formation & ranking', 'Open competitions', 'Token rewards', 'Futures contracts', 'Real-time updates'].map(f => (
                  <div key={f} className="flex items-center gap-2 text-sm text-[#888]">
                    <span className="text-[#C9A84C]">✓</span> {f}
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ── FEATURES ── */}
      <section id="features" className="bg-[#111] py-24 px-6">
        <div className="max-w-6xl mx-auto">
          <div className="text-center mb-16">
            <p className="text-xs font-semibold tracking-[0.15em] uppercase text-[#C9A84C] mb-3">What&apos;s In The App</p>
            <h2
              className="text-[clamp(2.5rem,6vw,4.5rem)] leading-none tracking-wide mb-4"
              style={{ fontFamily: "'Bebas Neue', sans-serif" }}
            >
              EVERYTHING YOUR
              <br />
              TRAINING DESERVES
            </h2>
            <p className="text-[#888] text-base max-w-lg mx-auto leading-relaxed">
              No bloat. No subscriptions to features you won&apos;t use. Just the tools that actually move the needle.
            </p>
            <div className="w-14 h-0.5 bg-[#C9A84C] mx-auto mt-6 rounded" />
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
            {FEATURES.map(({ icon, title, desc, badge, stat }) => (
              <div
                key={title}
                className="group relative bg-[#0f0f0f] border border-[#222] rounded-2xl p-7 hover:border-[rgba(201,168,76,0.4)] hover:-translate-y-1 hover:shadow-[0_20px_40px_rgba(0,0,0,0.5)] transition-all duration-300 overflow-hidden"
              >
                <div className="absolute top-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-[#C9A84C] to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                <div className="flex items-start justify-between mb-4">
                  <span className="text-3xl">{icon}</span>
                  {badge ? (
                    <span className="text-[10px] font-bold tracking-widest px-2 py-0.5 rounded bg-[rgba(201,168,76,0.15)] border border-[rgba(201,168,76,0.4)] text-[#C9A84C]">
                      {badge}
                    </span>
                  ) : (
                    <span className="text-[10px] font-mono text-[#555]">{stat}</span>
                  )}
                </div>
                <h3
                  className="text-xl tracking-wide mb-2 text-white"
                  style={{ fontFamily: "'Bebas Neue', sans-serif" }}
                >
                  {title}
                </h3>
                <p className="text-[#888] text-sm leading-relaxed">{desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── HOW IT WORKS ── */}
      <section className="bg-[#0a0a0a] py-24 px-6">
        <div className="max-w-5xl mx-auto">
          <div className="text-center mb-16">
            <p className="text-xs font-semibold tracking-[0.15em] uppercase text-[#C9A84C] mb-3">The Process</p>
            <h2
              className="text-[clamp(2.5rem,6vw,4.5rem)] leading-none tracking-wide mb-4"
              style={{ fontFamily: "'Bebas Neue', sans-serif" }}
            >
              THREE STEPS.
              <br />
              ZERO EXCUSES.
            </h2>
            <div className="w-14 h-0.5 bg-[#C9A84C] mx-auto mt-6 rounded" />
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {[
              {
                num: '01',
                icon: '👤',
                title: 'BUILD YOUR PROFILE',
                desc: 'Set your goals, fitness level, and body composition. This is the foundation — the AI uses this baseline to calibrate everything from day one.',
              },
              {
                num: '02',
                icon: '📋',
                title: 'TRAIN AND LOG EVERYTHING',
                desc: 'Every workout, run, meal, and night of sleep. The more data you feed it, the smarter your coaching becomes. The AI is only as good as your honesty.',
              },
              {
                num: '03',
                icon: '⚡',
                title: 'AI PRESCRIBES YOUR PROGRAM',
                desc: 'Your coach adapts weekly based on your actual data — progressive overload, carb cycling, recovery windows, all auto-calculated. It learns. It adjusts. It delivers.',
              },
            ].map(({ num, icon, title, desc }) => (
              <div key={num} className="relative bg-[#111] border border-[#222] rounded-2xl p-10 text-center hover:border-[rgba(201,168,76,0.3)] transition-all duration-300">
                <div
                  className="absolute top-4 right-5 text-7xl leading-none text-[rgba(201,168,76,0.06)]"
                  style={{ fontFamily: "'Bebas Neue', sans-serif" }}
                >
                  {num}
                </div>
                <div className="w-14 h-14 bg-[rgba(201,168,76,0.08)] border border-[rgba(201,168,76,0.25)] rounded-xl flex items-center justify-center text-2xl mx-auto mb-6">
                  {icon}
                </div>
                <h3
                  className="text-xl tracking-wide mb-3 text-[#C9A84C]"
                  style={{ fontFamily: "'Bebas Neue', sans-serif" }}
                >
                  {title}
                </h3>
                <p className="text-[#888] text-sm leading-relaxed">{desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── PRO vs FREE ── */}
      <section className="bg-[#111] py-24 px-6">
        <div className="max-w-4xl mx-auto">
          <div className="text-center mb-14">
            <p className="text-xs font-semibold tracking-[0.15em] uppercase text-[#C9A84C] mb-3">Plans</p>
            <h2
              className="text-[clamp(2.5rem,6vw,4.5rem)] leading-none tracking-wide mb-4"
              style={{ fontFamily: "'Bebas Neue', sans-serif" }}
            >
              FREE VS PRO
            </h2>
            <p className="text-[#888] text-base max-w-lg mx-auto leading-relaxed">
              At0m Fit is free to train with. Pro unlocks the AI coach that turns your data into a full program.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* Free */}
            <div className="bg-[#0a0a0a] border border-[#222] rounded-2xl p-8">
              <div className="mb-6">
                <div
                  className="text-3xl tracking-wide text-white mb-1"
                  style={{ fontFamily: "'Bebas Neue', sans-serif" }}
                >
                  FREE
                </div>
                <div className="text-[#555] text-sm">Core training tools. No cost, forever.</div>
              </div>
              <ul className="space-y-3">
                {FREE_FEATURES.map((f) => (
                  <li key={f} className="flex items-start gap-3 text-sm text-[#aaa]">
                    <span className="text-[#555] mt-0.5 shrink-0">✓</span>
                    {f}
                  </li>
                ))}
              </ul>
              <a
                href="#waitlist"
                className="block mt-8 text-center px-6 py-3 border border-[#333] rounded-xl text-[#888] text-sm font-bold tracking-widest uppercase hover:border-[#555] transition-colors"
              >
                Get Started Free
              </a>
            </div>

            {/* Pro */}
            <div className="bg-[rgba(201,168,76,0.05)] border border-[#C9A84C] rounded-2xl p-8 relative overflow-hidden">
              <div className="absolute top-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-[#C9A84C] to-transparent opacity-60" />
              <div className="mb-6">
                <div className="flex items-center gap-3 mb-1">
                  <div
                    className="text-3xl tracking-wide text-[#C9A84C]"
                    style={{ fontFamily: "'Bebas Neue', sans-serif" }}
                  >
                    PRO
                  </div>
                  <span className="text-[10px] font-bold tracking-widest px-2 py-0.5 rounded bg-[rgba(201,168,76,0.15)] border border-[rgba(201,168,76,0.4)] text-[#C9A84C]">
                    COMING SOON
                  </span>
                </div>
                <div className="text-[#888] text-sm">Full AI coaching — workouts, nutrition, sleep, recovery.</div>
              </div>
              <ul className="space-y-3">
                {PRO_FEATURES.map((f) => (
                  <li key={f} className="flex items-start gap-3 text-sm text-[#ccc]">
                    <span className="text-[#C9A84C] mt-0.5 shrink-0">✓</span>
                    {f}
                  </li>
                ))}
              </ul>
              <a
                href="#waitlist"
                className="block mt-8 text-center px-6 py-3 bg-[#C9A84C] rounded-xl text-black text-sm font-extrabold tracking-widest uppercase hover:shadow-[0_0_24px_rgba(201,168,76,0.35)] hover:-translate-y-px transition-all duration-200"
              >
                Join Pro Waitlist
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* ── SOCIAL PROOF ── */}
      <section className="bg-[#0a0a0a] py-16 px-6 border-t border-[#222]">
        <div className="max-w-4xl mx-auto text-center">
          <p className="text-xs font-semibold tracking-[0.15em] uppercase text-[#555] mb-8">Designed for the people who need it most</p>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
            {[
              {
                quote: '"Finally an app that treats training like it matters. Not a gamified step counter."',
                name: 'T. Harrington',
                role: 'SWAT / Beta tester',
              },
              {
                quote: '"The AI Brief every morning is genuinely different. It knows when I had a bad night and adjusts."',
                name: 'M. Castillo',
                role: 'Powerlifter / Beta tester',
              },
              {
                quote: '"The Compete screen is wild. I didn\'t know I needed a fitness trading floor until I had one."',
                name: 'D. Wu',
                role: 'CrossFit athlete / Beta tester',
              },
            ].map(({ quote, name, role }) => (
              <div key={name} className="bg-[#111] border border-[#222] rounded-2xl p-7 text-left">
                <p className="text-[#888] text-sm leading-relaxed mb-5 italic">{quote}</p>
                <div>
                  <div className="text-white text-sm font-semibold">{name}</div>
                  <div className="text-[#555] text-xs mt-0.5">{role}</div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── WAITLIST CTA ── */}
      <section id="waitlist" className="relative bg-[#0a0a0a] py-24 px-6 overflow-hidden border-t border-[#222]">
        <div className="absolute bottom-0 left-1/2 -translate-x-1/2 w-[600px] h-[600px] bg-[radial-gradient(circle,rgba(201,168,76,0.07)_0%,transparent_65%)] pointer-events-none" />

        <div className="max-w-xl mx-auto text-center relative">
          <p className="text-xs font-semibold tracking-[0.15em] uppercase text-[#C9A84C] mb-3">Limited Early Access</p>
          <h2
            className="text-[clamp(2.8rem,7vw,5rem)] leading-none tracking-wide mb-4"
            style={{ fontFamily: "'Bebas Neue', sans-serif" }}
          >
            JOIN THE
            <br />
            <span className="text-[#C9A84C]">WAITLIST</span>
          </h2>
          <p className="text-[#888] text-base mb-3 leading-relaxed">
            Get early access, lifetime perks, and a direct line to shape what At0m Fit becomes.
          </p>
          <p className="text-[#555] text-sm mb-10">
            Beta spots are limited. Early adopters get Pro access free at launch.
          </p>

          <form onSubmit={handleSubmit} className="flex flex-col sm:flex-row gap-3 max-w-md mx-auto">
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="your@email.com"
              required
              disabled={status === 'loading' || status === 'success'}
              className="flex-1 bg-[#111] border border-[#222] rounded-xl px-5 py-3.5 text-white text-base placeholder-[#555] focus:outline-none focus:border-[#C9A84C] focus:shadow-[0_0_0_3px_rgba(201,168,76,0.15)] transition-all disabled:opacity-50 disabled:cursor-not-allowed"
            />
            <button
              type="submit"
              disabled={status === 'loading' || status === 'success'}
              className={buttonClass()}
            >
              {buttonLabel()}
            </button>
          </form>

          {statusMessage()}

          <p className="text-xs text-[#444] mt-4">No spam. No fluff. Just early access when we launch.</p>
        </div>
      </section>

      {/* ── FOOTER ── */}
      <footer className="bg-[#0a0a0a] border-t border-[#222] py-10 px-6 text-center">
        <div
          className="text-3xl tracking-wider mb-2"
          style={{ fontFamily: "'Bebas Neue', sans-serif" }}
        >
          AT<span className="text-[#C9A84C]">0</span>M FIT
        </div>
        <p className="text-[#555] text-sm mb-6">Train like an operator. Recover like a pro.</p>
        <div className="flex justify-center gap-8 mb-6 flex-wrap">
          {['Privacy', 'Terms', 'Contact'].map((link) => (
            <a
              key={link}
              href={link === 'Contact' ? 'mailto:hello@at0mfit.com' : '#'}
              className="text-[#555] text-sm hover:text-[#C9A84C] transition-colors"
            >
              {link}
            </a>
          ))}
        </div>
        <p className="text-[#333] text-xs">At0m Fit © 2026. All rights reserved.</p>
      </footer>
    </main>
  )
}
