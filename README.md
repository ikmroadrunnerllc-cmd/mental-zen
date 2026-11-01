# Mental Zen

Mental Zen is an Android-first personal mood journal engineered with Flutter and Firebase. Designed for private daily emotional tracking, the app lets users record entries with a 5-point mood rating, maintain daily streaks, view chronological entry history, and receive actionable daily insights generated through a hybrid AI pipeline pairing an offline Dart lexicon baseline with a server-side Gemini Cloud Function.

## Prerequisites
- Flutter SDK (>= 3.22.0)
- Dart SDK (>= 3.4.0)
- Android SDK (API 34, Android 14)
- Node.js (v20 LTS) & npm (for Firebase Functions)
- Firebase CLI (`npm install -g firebase-tools`)
- Java 17+ (for Firebase Emulators)

## Firebase Setup & Local Emulators
Mental Zen is architected to run completely against the local Firebase Emulator Suite during development and testing.

1. Install emulator dependencies:
   ```bash
   firebase setup:emulators:firestore
   firebase setup:emulators:storage
   ```
2. Start the emulator suite (Auth: 9099, Firestore: 8080, Storage: 9199, Functions: 5001, UI: 4000):
   ```bash
   firebase emulators:start
   ```
3. Emulator UI is accessible at `http://localhost:4000`.

## Build Steps
1. Copy the environment template:
   ```bash
   cp .env.example .env
   ```
2. Fetch Flutter packages:
   ```bash
   flutter pub get
   ```
3. Run on a connected Android device or emulator:
   ```bash
   flutter run -d android
   ```
4. Build release APK:
   ```bash
   flutter build apk --release
   ```

## Test & Verification
Run the project verification script to enforce code formatting, static analysis, and test suites:
```bash
./scripts/verify.sh
```
Or run individual verification steps:
```bash
dart format --set-exit-if-changed lib test
flutter analyze
flutter test --coverage
```

## AI Provider Disclosure
Mental Zen uses the Google Gemini API (via server-side Firebase Cloud Functions on Node.js) to generate reflective daily mood insights. No user journal entries are sent directly to external model APIs from the client. Journal text is sanitized using PII regex redactions server-side before inference, and historical context is strictly restricted to numerical mood and sentiment ratings from the preceding 14 days. If the model is unreachable, rate-limited, or times out (>4s), the system seamlessly falls back to an offline, deterministic Dart lexicon scorer running locally on the device.

## Known Limitations
- **Platform:** Android-only focus for the undergraduate scope; iOS and web builds are not supported or tested.
- **App Check:** Firebase App Check enforcement is deferred in Milestone 1.
- **AI Quota:** Cloud Function insight generation is rate-limited to 20 calls per hour per user to avoid unexpected API usage spikes.
