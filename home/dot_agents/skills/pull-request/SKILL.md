---
name: pull-request
description: Write and open pull requests or merge requests on GitHub, GitLab or Codeberg/Forgejo. Use when the user asks to open, draft, describe or update a PR/MR, or to push a branch for review.
---

# Pull request

## Context

1. Forge from `git remote get-url origin`:
   - github.com → `gh pr`
   - GitLab (gitlab.com or a self-hosted `gitlab.` host) → `glab mr`
   - codeberg.org or another Forgejo/Gitea host → `fj pr`
   - Unknown host: ask.
2. Base branch: the repo's convention (history of merges, e.g. `feature → dev → main`); otherwise the default branch. Ask if unclear.
3. Current branch must not be the base branch; it must have commits ahead of the base (`git log --oneline <base>..HEAD`). Uncommitted changes: use the `commit` skill first.
4. Read the full diff against the base (`git diff <base>...HEAD`), not only the commit messages.

## Title

- Conventional prefix (`feat:`, `fix:`, `upd:`, `ref:`, `chore:`) and scope as in the commit history.
- One line describing the overall change, not the last commit.
- Language of the repo history.

## Body

Language of the repo history. Sections, skipping the empty ones:

```markdown
## Why
Problem or need, in one or two sentences. Link the issue if there is one.

## Changes
- What changes, grouped by area, one line each.

## Verification
- How it was tested: commands run, manual checks, what was not tested.

## Notes
- What the reviewer should look at, follow-ups, deploy or migration steps.
```

Writing:

- Write for the reviewer: why before what, effects before mechanics.
- Summarize the change; do not paste the commit list or the diff.
- Mention breaking changes, migrations and new configuration explicitly.
- No attribution footer or generated-by lines.

## Opening

1. Show title, base branch and body, and wait for approval.
2. Push: `git push -u origin <branch>`.
3. Create:
   - `gh pr create --base <base> --title <title> --body-file <file>`
   - `glab mr create --target-branch <base> --title <title> --description-file <file> --yes`
   - `fj pr create --base <base> --body-file <file> <title>`
4. Report the URL. Updating an existing PR/MR: same draft and approval, then `gh pr edit`, `glab mr update` or the `fj` equivalent.
