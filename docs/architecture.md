# Architecture — Mental Zen

## System Overview
Mental Zen is an Android-first personal mood journal engineered with Flutter and Firebase. The architecture enforces strict separation of concerns, offline resilience, and a deterministic fallback chain for AI-generated insights.

```
[UI Layer: Widgets & Screens]
           │
           ▼
[Domain Layer: Riverpod Providers, State Notifiers, Entities, Core Logic]
           │
           ▼
[Data Layer: Repositories & Data Sources]
           │
           ├─── Firestore (users/{uid}/**)
           ├─── Firebase Auth / Storage
           └─── Cloud Functions (Callable AI Insight Endpoint)
```

## Layers & Responsibilities

### UI Layer (`lib/features/<feature>/ui/`)
- Pure presentation and user interaction.
- Consume state exclusively through Riverpod `ConsumerWidget` or `ConsumerStatefulWidget`.
- **Constraint:** Widgets must NEVER import `cloud_firestore`, `firebase_auth`, or any Firebase SDK directly.

### Domain Layer (`lib/features/<feature>/domain/`)
- Encapsulates application state, business logic, entities, and validation rules.
- Manages state via Riverpod providers and state controllers.
- Models all remote, async, and loading states strictly using Riverpod's `AsyncValue` (`AsyncData`, `AsyncLoading`, `AsyncError`).
- Contains pure Dart logic (e.g., local lexicon analyzer, streak calculation engine) with zero framework or platform coupling.

### Data Layer (`lib/features/<feature>/data/`)
- Single source of truth for all remote and local data storage.
- Architecture dictates exactly **one repository per collection/domain boundary** (e.g., `EntryRepository`, `InsightRepository`, `AuthRepository`).
- Repositories are the sole access points to Firestore, Firebase Storage, and Cloud Functions.
- Translates Firestore `DocumentSnapshot` instances to strongly-typed domain entities and maps platform exceptions into domain exceptions.

## Trust Boundary & Security Model
- **Client validation** exists purely for immediate UX feedback (form input constraints, character limits, field presence).
- **Backend security rules** (`firestore.rules`, `storage.rules`) provide the authoritative security boundary. Client-supplied IDs, claims, or fields are untrusted; all Firestore queries and writes strictly require matching `request.auth.uid`.

## AI Insight Path & Deterministic Fallback Ladder
The application strictly prohibits direct client-to-model API calls. All model interactions occur server-side through a hardened Firebase Callable Function:

```
[User Submits Journal Entry]
           │
           ├─────────────────────────────┐
           ▼                             ▼
[1. Save Entry to Firestore]    [2. Run Offline Dart Lexicon Scorer]
   (Never blocks on AI)                  │ (Deterministic Baseline Score)
                                         ▼
                                [3. Dispatch Callable Function]
                                  Timeout: 4 seconds
                                  Retry: 1 attempt max
                                         │
                         ┌───────────────┴───────────────┐
                         ▼                               ▼
                 [Success (HTTP 200)]          [Failure / Timeout / Error]
                         │                               │
                         ▼                               ▼
                 Persist AI Insight             Fallback to Lexicon Baseline
                 (Display in UI)                Record non-fatal Crashlytics
                                                Display "Low Confidence" chip
```

1. **Step 1:** The user's entry is committed directly to local/remote Firestore. Saving entries never waits for or blocks on AI processing.
2. **Step 2:** The client immediately executes the pure Dart lexicon scorer (~200 sentiment stems + negators/intensifiers) locally, guaranteeing an immediate, zero-latency baseline.
3. **Step 3:** A background callable Cloud Function (`generateDailyInsight`) is invoked with a strict 4-second timeout and at most 1 retry.
4. **Step 4 (Fallback):** If the callable fails (network loss, timeout, cold start, rate limit, or model error), the application falls back immediately to the local lexicon baseline, tags the insight with a low-confidence badge, and logs a non-fatal event to Crashlytics.

## Open Risks & Mitigations

1. **Cloud Function Cold-Start Latency vs. 4-Second Timeout Window:**
   - *Risk:* Gemini inference via Cloud Functions (Node.js runtime on Firebase Blaze) can incur a 3–6 second cold start when idling, causing client-side timeouts.
   - *Mitigation:* The client aggressively falls back to the local Dart lexicon scorer upon reaching the 4-second threshold without failing entry persistence; subsequent warm calls complete well within the SLA.

2. **Offline-First Synchronization and Insight Race Conditions:**
   - *Risk:* Users in low-connectivity or airplane mode can record multiple entries. If the device comes back online hours later, delayed callable triggers might overwrite newer local baseline evaluations.
   - *Mitigation:* Daily insights are keyed deterministically by date (`users/{uid}/insights/{yyyy-mm-dd}`) using Firestore server timestamps and transactional guards to guarantee idempotency.

3. **Compound Index Requirements for Filtered History & Streak Queries:**
   - *Risk:* Real-time history filtering (e.g., mood range query combined with descending timestamp order) requires composite index definitions in Firestore. Missing indexes in production cause unhandled client query crashes.
   - *Mitigation:* Predefined composite indexes in `firestore.indexes.json` are tested and validated directly within local Firebase Emulator integration tests before deployment.
