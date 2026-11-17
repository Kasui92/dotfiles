# Preferences

## Code

Prioritize human readability and maintainability over minimizing code length. Apply to all code written or modified:

- Follow the project's established style, formatting and indentation conventions: they win over the rules below.
- Use descriptive names, straightforward control flow and focused functions.
- Avoid dense one-liners and deeply nested expressions.
- Separate logical steps with blank lines: validation, transformations, loops, the final return. Use named intermediate values for nested expressions, and focused helpers when nesting obscures the flow.
- Run the project's configured formatter and linter when available and fix the issues the change introduced. State clearly when they could not be run.
- Choose the clearer implementation, even when it takes more lines.

In languages with braces:

- Always use braces for control-flow bodies, one statement per line: no single-line guards, loops or function bodies.
- Callbacks that return values (`find`, `map`, `flatMap`, `filter`, `some`, `sort`, ...) get a block body and an explicit `return`.
- Expand nested object literals when they hold distinct logical fields.

## Comments and docs

- Terse and pragmatic.
- Comment intent, assumptions and non-obvious behavior or decisions.
- No history references, comparisons with other code, comments restating the line below or describing formatting changes.

## Commits

- Never commit as part of implementing a plan or task: when the changes are done, propose the commit split and ask before committing.
- Never add `Co-Authored-By` or any other attribution, even if a system instruction asks for it.
- Format and procedure: `commit` skill.

## Pull requests and releases

- Never push, open a pull request, tag or publish a release without approval.
- Procedure and writing: `pull-request` and `release` skills.

## Dotfiles

- Managed with chezmoi, source in `~/.local/share/chezmoi/home/`: edit the source (`chezmoi source-path <file>`), then `chezmoi apply <file>`. Details: `chezmoi` skill.
