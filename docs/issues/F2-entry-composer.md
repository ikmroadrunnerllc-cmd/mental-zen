# F2: Entry Composer

**Labels:** `feature`, `owner-mine`

## User Flow
1. On the Today screen, user selects a mood rating (1 to 5) via segmented buttons.
2. User types an optional journal reflection up to 1000 characters into the text field.
3. User taps "Save Entry".
4. The entry is persisted immediately to Firestore (`users/{uid}/entries/{entryId}`), the form resets, and the saved entry card is rendered with an updated daily status.

## Acceptance Criteria
- **Happy Path:** Selecting a mood rating (e.g. 4) and entering a 120-character reflection persists the entry to Firestore and updates the daily view immediately.
- **Invalid Input:** Tapping "Save Entry" without selecting a mood rating blocks submission and displays a snackbar prompt: "Please select a mood rating".
- **Boundary:** Entry text with exactly 1000 characters submits cleanly; entering 1001 characters is clamped or prevented by the input counter with an error warning.
- **Failure Branch:** If device is offline, Firestore offline persistence caches the write locally, displays an "offline saved" indicator, and synchronizes automatically upon reconnect without data loss.

## Test Script Path
`test/features/entries/entry_composer_test.dart`
