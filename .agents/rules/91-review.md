---
trigger: manual
description: "Self-review before opening a PR"
---
Read the branch diff as a stranger and answer in the PR body:
- Does it meet every acceptance criterion, including the failure branch?
- Any client-side authority a rule should hold?
- Any secret, hardcoded ID, or debug print?
- Do the tests actually fail without this diff?
- What did I not verify?
Then request a review from myself and leave at least one substantive comment.
