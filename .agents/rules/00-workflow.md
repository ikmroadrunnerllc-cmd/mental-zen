---
trigger: always_on
description: "Task loop and stop points"
---
# Loop
1. Restate the task in one sentence. If ambiguous, ask — one question, not five.
2. Name the open issue. None → stop.
3. Plan: files, approach, test, risk. Wait for go-ahead.
4. Write the failing test. Show it failing.
5. Implement minimally. Show the diff.
6. Run `./scripts/verify.sh`. Paste output verbatim.
7. Update `AI_Usage_Log.md`.
8. Commit with `refs #<issue>`.
9. Report: what changed, what's unverified, next step. Then stop.

## Escalate instead of guessing
Rule conflict · schema change · new dependency · anything touching auth or
security rules · a test that won't go green after two attempts.
