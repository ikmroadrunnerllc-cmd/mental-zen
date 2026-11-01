# Mental Zen — Agent Contract

Flutter + Firebase mood journal. Android only. Solo dev, undergraduate final project.
Everything here is graded on evidence: issues, commits, tests, live explanation.

## Read before starting any task
- `docs/architecture.md` — layers, state, data flow
- `docs/ai-contract.md` — the AI feature's inputs, outputs, baseline, metrics
- `docs/decisions/` — ADRs. Do not contradict a settled decision without saying so

## Hard rules
1. One task at a time. Never bundle two features in one response.
2. Issue first. If no open issue covers the task, say so and stop.
3. Plan before code: list files to touch, then wait for my go-ahead.
4. Test before implementation for any pure logic (lexicon, streak, validation).
5. Conventional commits: `feat|fix|test|docs|chore(scope): msg`. One logical change each.
6. Run `./scripts/verify.sh` after every change and paste the output. Never claim
   a test passed without its output.
7. Append to `AI_Usage_Log.md` after each accepted or rejected suggestion:
   date, task, what you proposed, accept/reject, why, how I verified.
8. Stop and report after each numbered step in `docs/timeline.md`. Do not roll into the next.

## Never
- Hardcode keys, project IDs, or URLs. Use `--dart-define` and `.env`.
- Commit `google-services.json`, `functions/.env`, or `*.jks`.
- Add a dependency without stating the version and why it beats what's installed.
- Rewrite a file wholesale to change a few lines; show a diff.
- Put Firestore reads inside `build()`.
- Trust client-side values for anything a rule can enforce.
- Call the model from the client. AI goes through the callable Function.
- Invent a metric, screenshot, or test result. If unmeasured, write "unmeasured".
- Mark a task done while `flutter analyze` reports warnings.

## Definition of done (all required before you say "done")
- [ ] Acceptance criteria from the issue met, including the invalid and failure branches
- [ ] Test exists and fails without the change, passes with it
- [ ] `flutter analyze` clean, `dart format` applied
- [ ] Offline/relaunch behavior verified where the feature persists state
- [ ] `AI_Usage_Log.md` updated
- [ ] Commit message names the issue: `refs #12`

## Architecture
`lib/features/<feature>/{ui,data,domain}/` · shared code in `lib/core/` ·
Firestore access only in `data/` repositories · no UI widget talks to Firebase directly.

## Scope guard
Undergraduate track. If a suggestion needs maps, sensors, AR, or a second backend,
flag it as bonus and don't build it without asking.
