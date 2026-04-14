---
description: Review a pull request using the project's REVIEWER.md guardrails. Checks out the branch, reads all referenced docs, explores changed files in full context, and confirms with you before posting comments. Usage: /review-pr [PR number]. If no argument given, uses the current branch's open PR.
agent: pr-reviewer
subtask: true
---

Review the pull request: $ARGUMENTS

If no PR number is provided, detect and review the open PR for the current branch.

Follow the full workflow defined in your system prompt:
1. Load REVIEWER.md and all referenced doc files
2. Fetch PR metadata with gh
3. Check out the PR branch with gh pr checkout
4. Read every changed file in full, plus related files for context
5. Apply every guardrail systematically
6. Present all findings to the user and wait for confirmation before posting
7. Post confirmed comments via gh
