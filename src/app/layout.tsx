import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'At0m Fit — Train Like An Operator',
  description: 'AI-powered fitness coaching built for people who don\'t quit. Personalized workouts, nutrition, run tracking, and recovery intelligence.',
  metadataBase: new URL('https://at0mfit.com'),
  openGraph: {
    title: 'At0m Fit — Train Like An Operator',
    description: 'AI-powered fitness coaching built for people who don\'t quit.',
    url: 'https://at0mfit.com',
    siteName: 'At0m Fit',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'At0m Fit — Train Like An Operator',
    description: 'AI-powered fitness coaching built for people who don\'t quit.',
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link
          href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet"
        />
      </head>
      <body className={inter.className}>{children}</body>
    </html>
  )
}
