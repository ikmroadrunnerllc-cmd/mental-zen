# Course Challenges (C1 - C4) — Mobile Design

## Challenge 1 (C1): Responsive Layout & Viewport Scaling
- **Scope:** Dynamic screen scaling across multiple Android device profiles, densities, and orientations (phones 360dp–412dp width and small tablets).
- **Happy Path:** Clean fluid rendering conforming to the 390x844 SVG specifications without text truncation or overflow bars on standard viewports.
- **Boundary / Stress:** Narrow 320dp width devices and extreme system font scaling (up to 200%) dynamically wrap buttons and preserve legible entry cards.
- **Failure Mode:** Overflow errors (`A RenderFlex overflowed...`) prevented via scrollable shells and responsive constraints.

## Challenge 2 (C2): Offline-First State Synchronization
- **Scope:** Complete journal write, read, and streak tracking capabilities under degraded or absent network conditions.
- **Happy Path:** All entry submissions save synchronously to local SQLite/disk cache and queue for remote Firestore sync upon reconnection.
- **Boundary / Stress:** Intermittent network flapping during save operations resolves idempotently without duplicating entry records.
- **Failure Mode:** Extended offline sessions (>7 days) continue to calculate accurate streaks locally from cached entries without stalling the UI.

## Challenge 3 (C3): Accessibility & Touch Ergonomics
- **Scope:** Strict Material 3 accessibility compliance, touch target sizing, and high-contrast readability.
- **Happy Path:** All interactive elements (mood buttons, back navigation, save triggers) maintain at least 48x48dp interactive bounding boxes.
- **Boundary / Stress:** System high-contrast mode and dynamic color theming preserve legible contrast ratios (>= 4.5:1 for body copy, >= 3:1 for controls).
- **Failure Mode:** Screen reader (TalkBack) traversal provides semantic labels for icon-only buttons, streak counts, and mood rating pills.

## Challenge 4 (C4): Low-Latency AI Degradation & Deterministic Fallback
- **Scope:** Fault-tolerant AI emotional reflection delivery with zero-latency baseline execution.
- **Happy Path:** Server-side Gemini 2.5 Flash callable generates actionable reflection (<160 chars) within 4 seconds.
- **Boundary / Stress:** Network latency > 4.0 seconds, HTTP 500 error, or offline state triggers immediate fallback to local pure Dart lexicon engine.
- **Failure Mode:** Complete API disconnection gracefully surfaces local lexicon sentiment score with visible "Low Confidence" badge without throwing unhandled exceptions.
