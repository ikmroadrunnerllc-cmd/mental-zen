# F9: Analytics and Crashlytics

**Labels:** `feature`, `owner-mine`

## User Flow
1. User interacts with key journal actions (creating an entry, toggling mood, generating insight, encountering errors).
2. Firebase Analytics logs privacy-preserving custom events (e.g. `entry_created`, `insight_fallback_triggered`, `data_exported`).
3. Non-fatal exceptions (e.g. AI timeout, Firestore rule rejection) are automatically captured and sent to Crashlytics with structured error codes.

## Acceptance Criteria
- **Happy Path:** Core actions record analytical events with sanitized parameters (mood integer, character count bucket, never entry text).
- **Invalid Input:** Events with PII text or raw journal text are prevented by strict domain event mapper methods.
- **Boundary:** Logging rapid events in offline mode queues reports locally and dispatches in batch once connectivity resumes.
- **Failure Branch:** Crashlytics initialization failure does not impede app startup or regular user interactions.

## Test Script Path
`test/features/settings/analytics_service_test.dart`
