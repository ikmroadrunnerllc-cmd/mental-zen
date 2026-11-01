---
trigger: manual
description: "End-of-session checkpoint"
---
1. `git status` — list uncommitted work.
2. Commit or stash everything; no dangling changes.
3. `docs/standup.md` — append today's date, what shipped (with issue numbers),
   what's blocked, tomorrow's first task.
4. Open issues for anything discovered but not done.
5. Run `./scripts/verify.sh`; record the result.
6. Summarise in five lines.
