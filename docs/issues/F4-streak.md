# F4: Streak

**Labels:** `feature`, `owner-mine`

## User Flow
1. User logs an entry for today.
2. The streak counter at the top of the Today screen increments if an entry was also logged yesterday (or starts at 1 if newly initiated).
3. If more than 24 hours pass across calendar day boundaries without an entry, the streak resets to 0.

## Acceptance Criteria
- **Happy Path:** Logging an entry on consecutive calendar days correctly increments the active streak count by 1.
- **Invalid Input:** Multiple entries logged on the same calendar day count as 1 active day, leaving streak unchanged rather than falsely inflating it.
- **Boundary:** Logging an entry at 23:59 and another at 00:01 counts as two distinct consecutive days, properly incrementing streak.
- **Failure Branch:** Timezone or clock changes on the local device do not corrupt the streak; date math uses UTC timestamps and compares calendar days relative to user's localized timezone offset.

## Test Script Path
`test/features/entries/streak_calculator_test.dart`
