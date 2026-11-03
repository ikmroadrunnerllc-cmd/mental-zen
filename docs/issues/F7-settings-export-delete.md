# F7: Settings, Export, and Account Deletion

**Labels:** `feature`, `owner-mine`

## User Flow
1. User opens Settings tab.
2. User can toggle AI insights on/off or export their entire journal data as a structured JSON file.
3. User can initiate account deletion with a confirmation prompt requiring explicit re-authentication.
4. Completing account deletion purges all entries, insights, storage assets, user doc, and Auth credentials, returning to Sign In screen.

## Acceptance Criteria
- **Happy Path:** Tapping "Export Data" aggregates all entries from Firestore and triggers a platform share/save intent with a valid JSON file.
- **Invalid Input:** Tapping "Delete Account" without typing "DELETE" or confirming re-auth dialog aborts the operation safely.
- **Boundary:** Exporting an account with 0 entries produces a valid JSON structure `{"version": 1, "entries": []}` without crashing.
- **Failure Branch:** Deletion failure midway through the cascade logs the incomplete state, presents a clear error, and preserves remaining data until re-attempted.

## Test Script Path
`test/features/settings/account_deletion_test.dart`
