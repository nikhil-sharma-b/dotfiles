---
name: commit
description: Commit staged and unstaged changes with a single-line message following the repo's commit conventions
disable-model-invocation: true
allowed-tools: Bash(git *)
---

# Commit Changes

Follow these steps exactly:

1. Run `git status` (never use `-uall`) to see what has changed.
2. Run `git diff` and `git diff --cached` to understand the changes.
3. Run `git log --oneline -10` to learn this repo's commit message style and conventions.
4. Stage the relevant changed files by name (prefer explicit paths over `git add -A`). Do NOT stage files that look like secrets (.env, credentials, tokens).
5. Write a **single-line** commit message that:
   - Matches the style and conventions observed in the repo's recent git log
   - Accurately summarizes the "why" of the changes (e.g. "add", "fix", "update", "refactor")
   - Is concise (under 72 characters)
6. Commit using a heredoc:
   ```
   git commit -m "$(cat <<'EOF'
   your message here

   Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
   EOF
   )"
   ```
7. Run `git status` to verify success.
8. If a pre-commit hook fails, fix the issue, re-stage, and create a NEW commit (never amend).

If the user provided arguments, treat `$ARGUMENTS` as an explicit commit message to use instead of generating one.
