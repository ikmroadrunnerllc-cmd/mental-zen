# F1: Authentication

**Labels:** `feature`, `owner-mine`

## User Flow
1. User opens the application for the first time and lands on the Sign In screen.
2. User enters an email and password or selects "Continue with Google".
3. Upon successful authentication, user session is stored and user navigates directly to the Today/Home screen.
4. If authentication fails, a clear inline error message appears, and the user stays on the sign-in screen.

## Acceptance Criteria
- **Happy Path:** Valid email/password credentials or Google token authenticate successfully and transition the app to the home dashboard.
- **Invalid Input:** Malformed email (e.g. `invalid-email`) or blank password immediately highlights the input field with local validation error text without hitting Firebase Auth.
- **Boundary:** Password with exactly 6 characters (Firebase minimum) succeeds; password with 5 characters is rejected with an inline requirement error.
- **Failure Branch:** When Firebase Auth returns `user-not-found`, `wrong-password`, or network timeout, the UI displays a mapped user-friendly error message via `AsyncValue.error` without crashing.

## Test Script Path
`test/features/auth/auth_repository_test.dart`
