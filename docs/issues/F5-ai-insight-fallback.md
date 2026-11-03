# F5: AI Insight + Fallback

**Labels:** `feature`, `owner-mine`

## User Flow
1. Upon logging an entry, the local Dart lexicon scorer immediately evaluates baseline sentiment and stores it.
2. A background Cloud Function (`generateDailyInsight`) is dispatched with the entry text and past 14 days' mood history.
3. If the model succeeds within 4 seconds, the insight card on the Today screen updates with actionable reflection text and identified topics.
4. If the call times out or fails, the card displays the local baseline insight with a "Low Confidence" badge.

## Acceptance Criteria
- **Happy Path:** Valid entry text triggers the callable Function; within 4s, UI renders an insight string (<= 160 chars) and topic pills with high/medium confidence.
- **Invalid Input:** Unchecked/empty text bypasses the callable entirely; lexicon scorer returns neutral score (0.0) without spending Cloud Function quota.
- **Boundary:** Entry text at exact 1000 character limit passes through regex PII redaction and callable successfully without truncation errors.
- **Failure Branch:** Function timeout (>4.0s), network failure, HTTP 500, or rate limit quota (20/hr) triggers graceful fallback to the local Dart lexicon text with a "Low Confidence" chip and non-fatal Crashlytics log.

## Test Script Path
`test/features/insight/insight_fallback_test.dart`
