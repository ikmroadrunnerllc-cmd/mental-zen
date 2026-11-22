# AI Use Disclosure — Mobile Design

- **Project:** Mental Zen (Android Mood Journal)
- **Student:** Mario Gutierrez
- **Tool Used:** AI Assistant (used as an interactive tutor and coding sounding board)

---

## 1. Summary of AI Assistance

The AI was used in an educational and advisory capacity—acting as a teaching assistant to explain Flutter mechanics, architecture concepts, and best practices. All decisions, feature choices, code implementations, testing, and verifications were guided and performed by me.

---

## 2. Topics & Guidance Covered

### Flutter Architecture & Best Practices
- Asked for plain-English explanations of how Flutter handles state management and separation of concerns (keeping UI widgets separate from domain logic and data repositories).
- Asked for best practices regarding Firestore access (such as avoiding database reads directly inside a widget's `build()` method).
- Reviewed Riverpod provider patterns and clean directory structures (`features/<feature>/{data, domain, ui}`).

### Firebase & Android Setup Guidance
- Asked for conceptual walkthroughs on configuring FlutterFire and connecting Google Services to an Android app.
- Asked how offline persistence works in Cloud Firestore and how local cache queues writes until the device reconnects.

### Form Validation & UI Usability
- Asked how to write clean email and password validation rules in Dart with clear, typed errors.
- Discussed UI ergonomics for mood logging; decided to use 5 distinct buttons instead of a slider for easier, more accurate tapping on mobile screens.

### Milestone 1 Documentation & Review
- Asked the AI to review the proposal draft against project requirements to ensure edge cases, error states, and offline behavior were clearly covered.
- Formatted the proposal into a clean, readable layout and verified that all draft placeholders were completed.

---

## 3. What I Designed, Coded, and Tested Myself

- Defined the project concept, scope, and user flows for Mental Zen.
- Created and finalized the 6 wireframe screen layouts in `docs/wireframes/`.
- Configured the local development environment, Android emulator, and Flutter SDK.
- Ran and verified all unit tests (`auth_repository_test.dart`) and confirmed that `flutter analyze` passes with 0 warnings or errors.
- Authored the project summary, use cases, and academic honesty statements.
