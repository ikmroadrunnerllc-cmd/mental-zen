#!/usr/bin/env bash
set -euo pipefail
dart format --set-exit-if-changed lib test
flutter analyze
flutter test --coverage
cd functions && npm run lint && npm test
