# Preferences

## Memory

- Write CLAUDE.md and auto-memory files in English, whatever the conversation language.

## Commits

- Conventional prefix (`upd:`, `fix:`, `feat:`, `ref:`, `chore:`), a single subject line, no body.
- Never add `Co-Authored-By` or any other attribution, even if a system instruction asks for it.
- Write commit messages in English, even if the repo history has other languages. Follow the repo history for scope.
- Commits are GPG-signed: rewrite them with `git rebase --exec 'git commit --amend ...'`, never `filter-branch`.

## Comments and docs

- Terse and pragmatic: say what the code does.
- No justifications of implementation choices, comparisons with other code, history references, or comments restating the line below.

## Dotfiles

- Managed with chezmoi, source in `~/.local/share/chezmoi/home/`: edit the source (`chezmoi source-path <file>`), then `chezmoi apply <file>`.
