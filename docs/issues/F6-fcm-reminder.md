# F6: FCM Reminder

**Labels:** `feature`, `owner-mine`

## User Flow
1. User enables "Daily Journal Reminder" in Settings and picks a preferred time (e.g., 20:00).
2. App requests notification permissions and saves the reminder preference.
3. At the scheduled time, a local/FCM notification alerts the user: "Time to reflect on your day in Mental Zen".
4. Tapping the notification opens the app directly into the entry composer.

## Acceptance Criteria
- **Happy Path:** Granted notification permission registers device token and schedules a recurring daily reminder at chosen hour.
- **Invalid Input:** Entering an invalid time format or leaving time empty falls back to the default reminder time (20:00).
- **Boundary:** Setting reminder time to 00:00 or 23:59 triggers cleanly across date roll-over boundaries.
- **Failure Branch:** User denies notification permission in system dialog; app gracefully disables the toggle and shows an explanatory notice without crashing.

## Test Script Path
`test/features/settings/reminder_service_test.dart`
