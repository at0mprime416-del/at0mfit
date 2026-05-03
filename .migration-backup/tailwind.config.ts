import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        accent: '#00d4ff',
        gold: '#FFD700',
        bg: '#0a0a0a',
        surface: '#111111',
        surface2: '#161616',
        border: '#222222',
      },
      fontFamily: {
        bebas: ['var(--font-bebas)', 'sans-serif'],
      },
    },
  },
  plugins: [],
}
export default config
