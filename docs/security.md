# Security & Access Control Matrix — Mental Zen

## 1. Firestore Security Rules Matrix

| Path / Collection Pattern | Read Access | Create Access | Update Access | Delete Access | Description / Constraints |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `users/{uid}` | `request.auth.uid == uid` | `request.auth.uid == uid` | `request.auth.uid == uid` | `request.auth.uid == uid` | User profile, preferences, streak counter |
| `users/{uid}/entries/{entryId}` | `request.auth.uid == uid` | `request.auth.uid == uid` | `request.auth.uid == uid` | `request.auth.uid == uid` | Private journal entries (text, mood 1-5, timestamps) |
| `users/{uid}/insights/{date}` | `request.auth.uid == uid` | `request.auth.uid == uid` | `request.auth.uid == uid` | `request.auth.uid == uid` | Computed daily mood summaries and AI insights |
| `aiEval/{runId}` | `request.auth != null` | `false` | `false` | `false` | Baseline evaluation runs; client read-only, write denied |
| `{document=**}` (All other paths) | `false` | `false` | `false` | `false` | Default deny rule for unmapped collections |

## 2. Cloud Storage Rules
- **Path:** `/users/{uid}/{allPaths=**}`
- **Permissions:** Owner-only read, write, and delete (`request.auth.uid == uid`).
- **File Constraints:**
  - Maximum size: 2 Megabytes (`request.resource.size <= 2 * 1024 * 1024`).
  - MIME types allowed: strictly `image/jpeg`, `image/png`, or `image/webp`.

## 3. Cloud Functions Security & Rate Limiting
- **Authentication Check:** The callable function verifies that `context.auth` is non-null and valid. Requests from unauthenticated clients return `UNAUTHENTICATED (401)`.
- **Rate Limiting:**
  - Enforced server-side via a transactional Firestore counter document: `users/{uid}/rate_limits/ai_insight`.
  - Cap: Maximum **20 calls per hour per authenticated UID**.
  - Exceeding the quota returns `RESOURCE_EXHAUSTED (429)` which the client gracefully catches and displays as an informative cooldown message without blocking entry storage.
- **Execution Timeout:** Hard ceiling of 4.0 seconds configured on the Cloud Function runtime.

## 4. Account Deletion Cascade Order
To adhere to privacy standards and clean up user data upon account deletion, data must be deleted in the following strict order:
1. `users/{uid}/entries/**` — recursively delete all entry subdocuments.
2. `users/{uid}/insights/**` — recursively delete all insight subdocuments.
3. Storage bucket: delete all objects stored under `/users/{uid}/`.
4. `users/{uid}` — delete the root user document.
5. Firebase Auth user record deletion (`user.delete()`).

## 5. Security Posture & Deferred Items
- **App Check:** App Check integration is explicitly deferred for Milestone 1 / undergraduate scope. Authentication relies on standard Firebase Auth tokens and rule validation.
- **API Secret Storage:** AI provider API keys are injected solely via Cloud Function runtime environment variables (`functions/.env`), never bundled inside the client Flutter APK or repository commits.
