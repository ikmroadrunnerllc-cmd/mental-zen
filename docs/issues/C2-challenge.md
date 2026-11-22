# C2: Offline-First State Synchronization

**Labels:** `challenge`, `owner-mine`

## Description
Complete journal write, read, and streak tracking capabilities under degraded or absent network conditions.

## Acceptance Criteria
- [ ] All entry submissions save synchronously to local disk cache and queue for remote Firestore sync upon reconnection.
- [ ] Intermittent network flapping during save operations resolves idempotently without duplicating entry records.
- [ ] Extended offline sessions (>7 days) continue to calculate accurate streaks locally from cached entries without stalling the UI.
