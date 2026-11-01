---
trigger: glob
globs: "test/**, integration_test/**"
description: "Test authoring requirements"
---
- Four cases minimum per feature: happy, invalid input, boundary, service failure.
- Fake the network, never the rules. Rules are tested against the emulator.
- Widget tests use `pumpAndSettle` and assert on Semantics, not pixels.
- A test that passes against a broken implementation is a bug — show it failing first.
- Name tests as behavior: `shows fallback chip when function returns 500`.
