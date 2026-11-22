# Mental Zen — Project Proposal (Milestone 1 — Mobile Design)

## 1. Team Information

### Team Member Roster

| Name | GitHub Handle | Role | Owned Scope |
| :--- | :--- | :--- | :--- |
| Mario Gutierrez | ikmroadrunnerllc-cmd | Lead Developer (Solo) | Full architectural design, Flutter client implementation, Firebase integration, offline baseline lexicon engine, and end-to-end testing across all project phases |

### Project Summary
Mental Zen is a private, Android-first personal mood journal developed for undergraduate students seeking mindful daily reflection. Users record an entry each day featuring a discrete 1-to-5 mood evaluation accompanied by an optional reflective journal entry of up to 1000 characters. The system tracks continuous daily journaling consistency through an automated streak counter and presents chronological entry history with filterable emotional trends. Each day, an actionable reflection card synthesizes recent emotional patterns from the previous 14 days without transmitting raw historical entry prose to third-party endpoints. Robust data protection is enforced directly at the backend boundary via owner-only Firestore security rules, while an offline-first architecture pairs a local Dart lexicon scorer with an optional server-side Cloud Function to provide deterministic fallbacks whenever network connectivity drops.

### Repository and Academic Integrity Statement
- **Repository URL:** https://github.com/ikmroadrunnerllc-cmd/mental-zen
- **Signed Contribution Statement:** Signed and staged at `docs/statements/member.md` for verification and grading.

---

## 2. Wireframe and Design

### Wireframe Architecture & Screen Captions

The user interface mockups are rendered as standalone, grayscale 390x844 SVG specifications located in `docs/wireframes/`.

```
docs/wireframes/
├── 01-signin.svg
├── 02-today.svg
├── 03-history.svg
├── 04-entry-detail.svg
├── 05-insight.svg
└── 06-settings.svg
```

#### Screen 01: Sign In (`01-signin.svg`)
- **Purpose:** Securely authenticate existing users or initiate registration via email/password credentials or federated Google Sign-In.
- **Primary Action:** Tap "Sign In" or "Continue with Google".
- **States Represented:**
  - *Empty:* Clean input fields with subtle hint text placeholders.
  - *Loading:* Disabled interactive buttons with a centered CircularProgressIndicator.
  - *Error:* Inline form field validation messages highlighting incorrect email formats or authentication rejections.
  - *Offline:* Visual warning banner indicating network unavailability for remote credential authentication.

#### Screen 02: Today / Composer (`02-today.svg`)
- **Purpose:** Serve as the daily landing workspace to record today's mood score, review active streaks, and input written reflections.
- **Primary Action:** Select a mood rating (1 to 5) and tap "Save Entry".
- **States Represented:**
  - *Empty:* Unselected mood buttons, empty 0/1000 character reflection box, and dynamic daily writing prompt.
  - *Loading:* Submission button disabled with progress indicator during local Firestore commit.
  - *Error:* Red highlight on segmented buttons if submission is attempted without an active mood selection.
  - *Offline:* Informational chip displaying "Offline Mode — Changes will sync when connected".

#### Screen 03: History (`03-history.svg`)
- **Purpose:** Browse past journal submissions chronologically with mood rating tags, timestamps, and emotional trend filtering.
- **Primary Action:** Tap any historical entry card to view the comprehensive detail page.
- **States Represented:**
  - *Empty:* Centered illustrative placeholder indicating "No journal entries yet" with a prompt to record the first reflection.
  - *Loading:* Skeleton placeholder cards simulating incoming Firestore stream data.
  - *Error:* Full-width warning banner with an interactive "Retry" button upon failed stream listener connection.
  - *Offline:* Renders previously cached entries from local disk cache with an offline status chip.

#### Screen 04: Entry Detail (`04-entry-detail.svg`)
- **Purpose:** Inspect a single journal entry in full depth, including complete reflection text, word count, identified topics, and baseline vs. model sentiment ratings.
- **Primary Action:** Tap the back navigation arrow to return to history or tap "Delete" to purge the record.
- **States Represented:**
  - *Empty:* Not applicable (direct drill-down screen).
  - *Loading:* Centered progress indicator while fetching specific entry document snapshot.
  - *Error:* Snack bar presentation stating "Unable to locate requested entry" followed by route pop.
  - *Offline:* Displays all persisted entry attributes directly from local cache without limitation.

#### Screen 05: Daily Insights (`05-insight.svg`)
- **Purpose:** Deliver daily AI pattern recognition synthesizing mood ratings and sentiment shifts over the trailing 14 calendar days.
- **Primary Action:** Review the featured insight card and inspect the 14-day mood distribution chart.
- **States Represented:**
  - *Empty:* "Log at least 3 entries to unlock pattern recognition" placeholder card.
  - *Loading:* Pulsing card outline while waiting for the 4-second Cloud Function response.
  - *Error:* Display of local Dart lexicon baseline insight alongside a prominent "Low Confidence" fallback chip.
  - *Offline:* Seamless fallback to local lexicon evaluation with a cached historical trend view.

#### Screen 06: Settings (`06-settings.svg`)
- **Purpose:** Manage account preferences, toggle AI analysis opt-in, configure local notification reminders, export data, and request complete account deletion.
- **Primary Action:** Toggle settings switches or initiate data export.
- **States Represented:**
  - *Empty:* Standard profile card with default preference states.
  - *Loading:* Progress modal during JSON export generation or account purge cascade.
  - *Error:* Dialog prompt alerting the user if export fails or re-authentication is required prior to deletion.
  - *Offline:* Cloud-dependent controls (e.g. account deletion) disabled with clear tooltips.

### Navigation Flow

```
[Sign In / Registration Screen]
              │ (Authentication Success)
              ▼
    [Main Navigation Shell]
    ├─── [Tab 1: Today Screen]
    │          │
    │          └─── [Save Entry Action] ──► (Triggers Local Baseline + Async Callable)
    │
    ├─── [Tab 2: History Screen]
    │          │
    │          └─── [Tap Entry Card] ──► [Entry Detail Screen]
    │                                          │
    │                                          └─── [Delete Entry Dialog]
    │
    ├─── [Tab 3: Insights Screen]
    │          │
    │          └─── [14-Day Trend Chart & Daily Insight Card]
    │
    └─── [Tab 4: Settings Screen]
               │
               ├─── [AI Opt-in Switch]
               ├─── [Daily Reminder Time Picker]
               ├─── [Export Data (JSON Share)]
               └─── [Delete Account Flow] ──► (Confirmation Dialog ──► Sign In)
```

### Core Use Cases

1. **Daily Mood & Reflection Capture:** A student opens the application after lectures, taps mood rating "4", types a brief 80-word summary of accomplishments, and taps "Save Entry". The entry is stored immediately in Firestore, updating the streak counter from 4 to 5 days without lag.
2. **Reviewing Emotional Trajectory:** A student feeling anxious reviews the History screen, filters by "Mood 1-2", and reflects upon earlier stressful periods to recall coping strategies and positive turnarounds.
3. **Receiving Contextual Daily Insights:** After completing three days of study sessions, the user visits the Insights screen to read an automated pattern summary ("Your mood correlates strongly with finishing tasks before evening hours"), noting the "High Confidence" indicator.
4. **Offline Journaling on the Go:** A student writes a journal entry while commuting on the subway without cellular service. The entry is securely written to local disk cache; upon exiting the station, Firestore synchronization automatically propagates the record.
5. **Privacy Management & Data Export:** A student opts to backup their reflections, navigating to Settings, tapping "Export Journal Data", and saving a single JSON file containing all historical entries to their local device storage.
6. **Account Termination:** A student leaves the university and triggers account deletion. The app enforces a confirmation prompt, sequentially cascades deletion across all entries, insights, storage objects, and auth records, and navigates back to the initial sign-in view.

### Iterative Design Note
During formative paper prototype evaluations with three undergraduate peers, participants interacted with a continuous 1-to-5 slider to report mood. All three testers repeatedly overshot their intended numerical rating due to imprecise touch targets on small mobile viewports. Based on this direct feedback, the slider was replaced with an explicit Material 3 five-segment button group (`1 | 2 | 3 | 4 | 5`). Follow-up testing confirmed 100% first-attempt input accuracy and significantly reduced cognitive burden.

### Selected System Test Cases

- **Test Case 1 (Empty Save):** Tapping "Save Entry" with no mood rating selected displays an immediate validation warning; no Firestore document write is dispatched.
- **Test Case 2 (1001 Characters Boundary):** Pasting a string of 1001 characters into the reflection input clamps at exactly 1000 characters and highlights the character counter in error state.
- **Test Case 3 (Cross-User Read Prevention):** Attempting to execute a Firestore read against `users/OTHER_USER_UID/entries` via client code returns a permission-denied error from backend security rules.
- **Test Case 4 (Airplane-Mode Save):** With device Wi-Fi and mobile data toggled off, saving an entry succeeds locally, increments the local streak, and syncs to the remote emulator immediately once connectivity is restored.
- **Test Case 5 (Function 500 / Timeout Fallback):** Simulating a Cloud Function 500 failure or 4-second timeout triggers the local Dart lexicon baseline scorer, rendering the baseline text alongside a visible "Low Confidence" badge without failing entry persistence.

---

## 3. Technical Details

### Platform Architecture & Stack Justification

- **Framework:** Flutter (Android SDK API 34 target). A single strongly-typed Dart codebase provides rapid, reactive UI iteration while ensuring native performance and accessibility semantics.
- **State Management:** Riverpod (via `flutter_riverpod`). Enforces unidirectional data flow, explicit compile-time safety, separation of domain logic from widgets, and structured handling of async remote data through `AsyncValue`.
- **Backend & Cloud Infrastructure:** Firebase Suite (Google Cloud). Using Firebase allows rapid solo development backed by enterprise-grade infrastructure. The security rules engine provides the authoritative trust boundary rather than relying on client-side checks.
- **Deterministic AI Baseline:** Pure Dart Lexicon Engine. Running an offline sentiment scorer on the device ensures zero latency, zero cloud costs, and complete offline availability for core features.

### Planned Services & APIs

1. **Firebase Authentication:** Handles email/password and Google OAuth credential lifecycles.
2. **Cloud Firestore:** Real-time NoSQL document database configured with offline persistence.
3. **Cloud Storage for Firebase:** Encrypted object store for user media attachments with strict 2MB limits.
4. **Firebase Cloud Functions:** Node.js 20 runtime hosting callable endpoints for secure, server-side Gemini API mediation.
5. **Firebase Cloud Messaging (FCM):** Push notification transport for user-configured daily reflection reminders.
6. **Firebase Remote Config:** Over-the-air management of operational parameters, character limits, and prompt version flags.
7. **Firebase Analytics:** Privacy-preserving usage metrics (tracking counts and categorical actions without PII).
8. **Firebase Crashlytics:** Real-time crash reporting and non-fatal fallback exception tracking.
9. **AI Logic Engine (Service 10):** Google Gemini 2.5 Flash mediated via Cloud Functions with deterministic fallback to the local Dart lexicon scorer.
*(Note: Firebase App Check is explicitly deferred for the undergraduate scope).*

### Firestore Database Schema

#### 1. Collection: `users/{uid}`
- `uid`: String (document ID matching Firebase Auth UID)
- `email`: String (user contact address)
- `displayName`: String (user display alias)
- `currentStreak`: Number (active consecutive days logged)
- `lastEntryDate`: String (`yyyy-mm-dd` format)
- `aiEnabled`: Boolean (user opt-in toggle for cloud AI features)
- `reminderTime`: String (`HH:mm` format, e.g. `"20:00"`)
- `createdAt`: Timestamp (server timestamp)
- `updatedAt`: Timestamp (server timestamp)

#### 2. Subcollection: `users/{uid}/entries/{entryId}`
- `entryId`: String (auto-generated document ID)
- `userId`: String (owner UID)
- `date`: String (`yyyy-mm-dd` format)
- `mood`: Number (integer from 1 to 5)
- `text`: String (user written reflection, <= 1000 characters)
- `wordCount`: Number (computed integer word count)
- `baselineSentiment`: Number (floating point score -1.0 to 1.0 from Dart lexicon)
- `createdAt`: Timestamp (server timestamp)
- `updatedAt`: Timestamp (server timestamp)

#### 3. Subcollection: `users/{uid}/insights/{yyyy-mm-dd}`
- `date`: String (document ID, `yyyy-mm-dd` format)
- `userId`: String (owner UID)
- `insight`: String (synthesized actionable feedback, <= 160 characters)
- `sentiment`: Number (floating point score -1.0 to 1.0)
- `topics`: Array of Strings (up to 5 lowercase topic identifiers)
- `confidence`: String (`"low"`, `"medium"`, or `"high"`)
- `isFallback`: Boolean (true if generated by offline lexicon fallback)
- `promptVersion`: String (semantic version of function prompt, e.g. `"v1.0.0"`)
- `createdAt`: Timestamp (server timestamp)

#### 4. Collection: `aiEval/{runId}`
- `runId`: String (evaluation batch timestamp identifier)
- `datasetVersion`: String (e.g. `"entries.json-v1"`)
- `accuracy`: Number (percentage match against ground truth)
- `cohenKappa`: Number (chance-adjusted agreement metric)
- `p95LatencyMs`: Number (95th-percentile execution time in milliseconds)
- `fallbackRate`: Number (percentage of calls falling back to baseline)
- `timestamp`: Timestamp (server timestamp)

### Security and Data Protection Posture

- **Ownership Assertions:** Every subcollection under `users/{uid}` strictly enforces `request.auth.uid == uid` across all read, write, update, and delete actions. Cross-user access is impossible at the database protocol level.
- **Client Write Denial:** The `aiEval` collection is strictly readable by authenticated users and denies all client-side write permissions; evaluations are recorded solely by backend processes.
- **Storage Limits:** Cloud Storage rules restrict uploads strictly to `request.auth.uid == uid`, enforce a 2MB maximum payload size, and reject non-image MIME types.
- **Rate Limiting & Execution Caps:** Cloud Functions execute an authentication check and increment a transactional counter capping requests at 20 calls per hour per user. Execution runtime is hard-capped with a 4.0-second timeout.
- **PII Scrubbing:** All payloads sent to Cloud Functions undergo regex redaction of capitalized proper names prior to dispatching to the Gemini API.
- **Cascading Deletion:** Account deletion triggers an orderly sequence: entry documents -> insight documents -> storage files -> user profile document -> Auth account record.
- **Environment Isolation:** All secret keys and model identifiers are stored in `functions/.env` and injected via `--dart-define`, strictly excluded from version control via `.gitignore`.

### AI Feature Contract (Specification Summary)

The AI capability adheres to the frozen specification recorded in `docs/ai-contract.md`:
- **Input Constraints:** Reflection text <= 1000 characters, mood score 1-5, and trailing 14 calendar days represented strictly as `{date, mood, sentiment}` objects. No raw past entry text is ever shared.
- **Output Constraints:** Sentiment rating (-1.0 to 1.0), topic tags list (maximum 5 items), actionable reflection text (maximum 160 characters), and confidence indicator (`low`, `medium`, `high`).
- **Deterministic Baseline:** Pure Dart offline lexicon scorer incorporating ~200 calibrated stems, valence-inverting negators, and 1.5x intensifiers. The baseline executes for every entry and remains persisted regardless of remote model success.
- **Evaluation Dataset:** `assets/eval/entries.json` containing 30 hand-crafted student entries (10 positive, 10 negative, 10 adversarial edge cases including sarcasm, double negatives, and hedged phrasing).
- **Core Evaluation Metrics:** Accuracy, Cohen's kappa, p95 round-trip latency, and fallback frequency.
- **Documented Failure Cases:** Documented misses include sarcastic sentiment inversion (*"Oh fantastic, another four-hour debugging session"*), double negative relief (*"cannot say I am not relieved"*), and split past-vs-present sentiment trajectories.
- **Fallback Hierarchy:** If execution exceeds 4 seconds, returns non-200, or reports low confidence (<0.6), the application seamlessly displays the lexicon baseline with an inline "Low Confidence" badge and logs a non-fatal event to Crashlytics.
- **Privacy Stance:** Users must explicitly opt-in to AI insights; all prospective personal name identifiers are redacted via regex before API dispatch, and model provider details are published in `README.md`.

### Acceptance Criteria Matrix

| ID | Feature Name | Happy Path | Invalid / Boundary | Failure Mode | Evidence (Test Path & Demo Step) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **F1** | Authentication | Valid email/pass or Google auth transitions to Today screen | Email missing '@' or password < 6 chars shows inline error | Invalid credentials or timeout displays mapped error banner | `test/features/auth/auth_repository_test.dart` (Demo: Login with test user) |
| **F2** | Entry Composer | Selecting mood (1-5) and text saves entry to Firestore | Submitting without mood shows warning; text clamps at 1000 chars | Airplane mode saves to local cache and syncs on reconnect | `test/features/entries/entry_composer_test.dart` (Demo: Submit entry offline) |
| **F3** | History List | Chronological list renders reverse order with mood pills | Empty journal state displays dedicated placeholder card | Disconnected network renders retry banner without crash | `test/features/history/history_repository_test.dart` (Demo: Filter by mood) |
| **F4** | Streak Counter | Consecutive calendar day submissions increment streak by 1 | Multiple entries in one day count once; gap > 24h resets to 0 | Clock or timezone changes calculate safely via UTC date math | `test/features/entries/streak_calculator_test.dart` (Demo: Streak badge update) |
| **F5** | AI Insight & Fallback | Callable function returns <= 160 char insight within 4s | Empty entry skips callable; 1000 char text redacts PII cleanly | Function timeout or 500 displays baseline with "Low Confidence" chip | `test/features/insight/insight_fallback_test.dart` (Demo: Trigger timeout fallback) |
| **F6** | FCM Reminder | Daily reminder scheduled at selected hour (default 20:00) | Invalid time input falls back to 20:00 default safely | Permission denial gracefully disables toggle without crash | `test/features/settings/reminder_service_test.dart` (Demo: Receive local reminder) |
| **F7** | Settings / Export / Delete | Export produces valid JSON; deletion purges all subcollections | Deletion requires typing "DELETE" to prevent accidental loss | Partial network failure halts cascade and preserves remaining data | `test/features/settings/account_deletion_test.dart` (Demo: Export JSON file) |
| **F8** | Remote Config | Dynamic parameters update client flags on startup | Malformed remote payload defaults safely to local constants | Offline launch loads bundled in-app defaults seamlessly | `test/features/settings/remote_config_test.dart` (Demo: Override prompt version) |
| **F9** | Analytics & Crashlytics | User actions record sanitized events (mood integer, word bucket) | Raw journal text and PII are strictly excluded from events | Offline actions queue locally and batch dispatch on reconnect | `test/features/settings/analytics_service_test.dart` (Demo: Crashlytics dashboard) |
| **C1** | Responsive Layout & Scaling | 390x844 SVG specs adapt cleanly across standard Android viewports | Narrow 320dp width and 200% font scale wrap gracefully | Scroll shells prevent RenderFlex overflow errors | `docs/issues/C1-challenge.md` (Demo: Multi-device rotation) |
| **C2** | Offline-First Synchronization | Submissions save synchronously to local disk cache and sync on reconnect | Network flapping during save resolves idempotently without duplication | Extended offline (>7d) calculates streaks locally without stalling UI | `docs/issues/C2-challenge.md` (Demo: Airplane-mode journal session) |
| **C3** | Accessibility & Ergonomics | Material 3 touch targets (>= 48dp) and contrast >= 4.5:1 | High-contrast system mode and dark/light dynamic colors render cleanly | TalkBack screen reader provides semantic descriptions for all pills/buttons | `docs/issues/C3-challenge.md` (Demo: Screen reader traversal) |
| **C4** | AI Low-Latency Degradation | Server-side Gemini callable delivers actionable insight within 4s | Empty entry skips callable; 1000 char text redacts PII cleanly | Timeout or 500 error displays local lexicon baseline with "Low Confidence" badge | `docs/issues/C4-challenge.md` (Demo: Simulated timeout fallback) |

### Milestone Development Timeline

- **Days 1–3 (Proposal & Scaffolding):** Establish Git repository, author project proposal, draft wireframes, define architecture, and curate baseline eval set.
- **Days 4–10 (Core Infrastructure, Auth & Entries):** Provision Firebase project, build authentication flows, implement entry composer, history views, and validate Firestore security rules.
- **Days 11–15 (Baseline Lexicon, Cloud Functions & Insights):** Build offline Dart sentiment engine, author Node.js callable Cloud Function with Gemini API, integrate insight card, and test fallback ladder.
- **Days 16–19 (Notifications & Observability):** Implement FCM reminders, configure Firebase Remote Config, wire Analytics events, and instrument Crashlytics reporting.
- **Days 20–22 (Model Evaluation & Account Tools):** Run comprehensive evaluation suite against `assets/eval/entries.json`, log performance metrics, build data export, and test cascading account deletion.
- **Days 23–25 (Packaging, Verification & Demo):** Finalize documentation, enforce verification scripts, build release Android APK, and record final demonstration video.
