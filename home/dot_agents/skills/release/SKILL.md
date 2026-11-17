---
name: release
description: Prepare and publish a release: next version, tag, release notes and changelog. Use when the user asks to release, tag a version, write release notes or update a CHANGELOG.
---

# Release

## Context

1. Forge from `git remote get-url origin`, as in the `pull-request` skill (`gh release`, `glab release`, `fj release`).
2. Version scheme from the existing tags (`git tag --sort=-creatordate | head`):
   - `vX.Y.Z` / `X.Y.Z`: semver.
   - `YYYYMMDD.N`: CalVer, date plus a daily counter.
   - `package@X.Y.Z`: monorepo release tooling (changesets, release-it, ...): use the repo's scripts, do not tag by hand.
   - No tags: ask.
3. Tag type from history: `git cat-file -t <last-tag>` (`tag` = annotated, `commit` = lightweight).
4. Release flow from history: if releases arrive through a merge from an integration branch (e.g. `dev → main`) and the tag sits on that merge, open that merge with the `pull-request` skill first, titled with the version.
5. Release tooling or CI jobs triggered by tags (`.gitlab-ci.yml`, `.github/workflows`, `.forgejo/workflows`, `package.json` scripts): follow them instead of duplicating their steps.

## Next version

- Changes: `git log <last-tag>..HEAD --no-merges --oneline`, plus the diff when messages are vague.
- Semver: breaking change → major, `feat` → minor, otherwise patch. Before 1.0, breaking → minor.
- CalVer: today's date; counter = highest existing counter for today + 1, else 1.
- Propose the version with the reason; the user decides.

## Notes

Language of the repo history. Structure, skipping empty sections:

```markdown
## Breaking changes
- What breaks and how to migrate.

## New
- Features.

## Fixes
- Bugs fixed.

## Changes
- Improvements and behavior changes.
```

Writing:

- Write for the users of the project, not for its developers: what they can do now, what behaves differently.
- One line per change; merge related commits; drop `ref` and `chore` unless users notice them.
- No commit hashes, author names or attribution lines.
- `CHANGELOG.md` present: add the release in its existing format, newest first, and include it in the release commit.

## Publishing

1. Show version, tag target commit, notes and changelog diff, and wait for approval.
2. Changelog or version-file changes: commit with the `commit` skill (`chore: release <version>` or the repo's equivalent).
3. Tag: `git tag -a <version> -m <version>` or `git tag <version>`, matching history. Signed tags (`-s`) if earlier tags are signed (`git tag -v <last-tag>`).
4. Push: `git push origin <branch>` then `git push origin <version>`.
5. Release on the forge with the notes, unless CI creates it from the tag:
   - `gh release create <version> --title <version> --notes-file <file>`
   - `glab release create <version> --name <version> --notes-file <file>`
   - `fj release create --tag <version> --body "$(cat <file>)" <version>`
6. Report the URL.
