# F8: Remote Config

**Labels:** `feature`, `owner-mine`

## User Flow
1. App initializes Firebase Remote Config on launch with local in-app defaults.
2. Background fetch pulls current feature flags (e.g., `ai_insight_enabled`, `max_entry_characters`, `prompt_version`).
3. App adopts updated parameters dynamically without requiring an app store update.

## Acceptance Criteria
- **Happy Path:** Remote Config values fetch successfully and configure client parameters (e.g. `max_entry_characters: 1000`).
- **Invalid Input:** Malformed or type-mismatched parameters from server default back safely to bundled in-app defaults.
- **Boundary:** Zero-second cache expiration in debug mode allows immediate testing of flag toggles.
- **Failure Branch:** When offline or Firebase Remote Config returns network timeout, the application continues seamlessly using bundled static fallback defaults.

## Test Script Path
`test/features/settings/remote_config_test.dart`
