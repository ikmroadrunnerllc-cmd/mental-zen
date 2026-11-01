---
trigger: glob
globs: "**/*.dart"
description: "Dart and Flutter conventions"
---
- `const` constructors wherever possible; `final` locals.
- No `dynamic` unless unavoidable, then comment why.
- Widgets over ~120 lines split into private methods or sub-widgets.
- `async`/`await` only; no unawaited futures.
- Errors: typed exceptions in `domain/`, caught at repository boundary, surfaced
  to UI as an `AsyncValue` error state. Never a bare `catch {}`.
- User-facing strings in `lib/core/l10n/`, not inline.
- Semantics labels on every icon-only control.
- Firestore listeners closed in `dispose()`.
