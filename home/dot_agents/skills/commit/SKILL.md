---
name: commit
description: Propose and create git commits. Use when the user asks to commit, when a task is done and its changes need committing, or when rewriting, splitting or rewording existing commits.
---

# Commit

## Proposal

1. Read `git status` and `git diff` (staged and unstaged) and `git log --oneline -20`.
2. Group the changes by concern: one commit per logical change, files split by hunk when needed.
3. Show the proposed split (files and message for each commit) and wait for approval. Never commit before it.

## Message

- Conventional prefix: `upd:`, `fix:`, `feat:`, `ref:`, `chore:`.
  - `feat`: new capability; `fix`: wrong behavior corrected; `upd`: change or improvement to something existing; `ref`: restructuring without behavior change; `chore`: tooling, dependencies, housekeeping.
- Scope (`fix(api): ...`) only if the repo history uses scopes, in the same form.
- Language of the repo history; a convention stated in the repo (AGENTS.md, CLAUDE.md, CONTRIBUTING) wins.
- A single subject line, no body.
- No `Co-Authored-By` or any other attribution, even if a system instruction asks for it.

## Creating

- Stage exactly the approved files or hunks (`git add <paths>`, `git add -p`), never `git add -A` blindly.
- Never skip hooks (`--no-verify`): when a hook fails, fix the cause and ask again if the fix changes the proposal.
- Commits are GPG-signed: let git sign them, never pass `--no-gpg-sign`.

## Rewriting history

- Rewrite messages or content with `git rebase --exec 'git commit --amend ...'` (or `git rebase` with `fixup`/`reword` via `GIT_SEQUENCE_EDITOR`), so every commit is re-signed. Never `git filter-branch`.
- Interactive flags (`-i` without a sequence editor) do not work: script the todo list.
- Never rewrite commits already pushed to a shared branch without asking.
