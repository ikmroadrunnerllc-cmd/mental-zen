# ADR 0001: Feature-First Modular Folder Structure

## Status
Accepted

## Date
2026-11-20

## Context
In building Mental Zen with Flutter and Riverpod, codebase organization must support solo development, clear test boundaries, and strict encapsulation. Codebases are typically organized either by horizontal layers (`lib/views`, `lib/models`, `lib/controllers`), by pages (`lib/pages`), or by vertical slices/features (`lib/features/<feature>/{ui,data,domain}`).

## Decision
We organize the codebase using a **feature-first layered folder structure**:
```
lib/
  core/
    l10n/
    theme/
    router/
    widgets/
  features/
    auth/
      data/
      domain/
      ui/
    entries/
      data/
      domain/
      ui/
    history/
      data/
      domain/
      ui/
    insight/
      data/
      domain/
      ui/
    settings/
      data/
      domain/
      ui/
```

## Alternatives Considered

1. **Layer-First (`lib/views`, `lib/models`, `lib/repositories`):**
   - *Pros:* Familiar in small tutorials; simple initially.
   - *Cons:* Files belonging to the same feature are scattered across directories. Adding or deleting a feature requires navigating and modifying distant folders, increasing cognitive load and merge conflicts.

2. **Page-First (`lib/pages`):**
   - *Pros:* Aligns closely with routes.
   - *Cons:* Blurs the separation between presentation, state, and data repositories, leading to direct Firestore calls inside UI widgets and untestable code.

## Consequences

- **Positive:**
  - High cohesion: all presentation, business logic, and data handling for a bounded context (e.g., `entries`) reside in one location.
  - Testability: pure domain logic and data repositories can be tested independently of UI widgets.
  - Clear isolation: deleting or refactoring a feature has a well-defined blast radius.
- **Negative / Constraints:**
  - **Import discipline required:** Developers must resist cross-feature private imports. Cross-cutting shared components (typography, base layouts, routing) must live exclusively in `lib/core/`.
  - Feature-to-feature communication must happen through exposed domain interfaces or top-level Riverpod providers, never direct UI couplings.
