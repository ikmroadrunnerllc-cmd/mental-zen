---
trigger: model_decision
description: "Firestore schema, security rules, Functions, and Storage work"
---
- Paths: `users/{uid}`, `users/{uid}/entries/{entryId}`, `users/{uid}/insights/{date}`.
- Every subcollection rule asserts `request.auth.uid == uid`. New collection
  without a matching rule is not done.
- `aiEval` is client-read, client-write denied.
- Server timestamps (`FieldValue.serverTimestamp()`), never `DateTime.now()` for ordering.
- Callable Functions: verify `context.auth`, rate-limit via counter doc, 4 s
  timeout, return a typed error code the client maps to UI.
- Never widen a rule to make a test pass. Fix the query instead.
- Update `docs/security.md` in the same commit as any rule change.
