# F3: History

**Labels:** `feature`, `owner-mine`

## User Flow
1. User navigates to the History tab from bottom navigation.
2. The screen loads the list of journal entries in reverse chronological order (newest first).
3. User scrolls to review past days and can filter entries by specific mood (1-5).
4. Tapping an entry opens the detailed view showing date, mood score, full text, and sentiment summary.

## Acceptance Criteria
- **Happy Path:** Screen renders past entries ordered by `createdAt` descending with distinct mood indicators and truncated preview text.
- **Invalid Input:** Requesting history for an unauthenticated session throws a typed `UnauthenticatedException` caught at the repository boundary and presents a login prompt.
- **Boundary:** Empty state renders a dedicated "No journal entries yet" graphic and prompt to log the first entry when total count is 0.
- **Failure Branch:** Network disconnection during initial fetch triggers `AsyncValue.error`, showing a "Could not load history" error banner with a "Retry" button.

## Test Script Path
`test/features/history/history_repository_test.dart`
