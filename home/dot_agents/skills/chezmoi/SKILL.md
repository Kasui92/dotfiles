---
name: chezmoi
description: Edit dotfiles managed by chezmoi. Use when changing any file under the home directory (~/.config, ~/.bashrc, ~/.claude, ~/.codex, ~/.local/bin, ...), adding a new dotfile, or working in a chezmoi source directory.
---

# chezmoi

## Finding the source

- `chezmoi source-path <target>` gives the source file; `chezmoi managed` lists the managed targets.
- A second chezmoi source (e.g. the work repo, managed with `cmw`) may own the file: if the personal source does not manage it, check that one too.
- Not managed by any source: edit the target directly, or ask whether to add it (`chezmoi add <target>`).

## Editing

- Edit the source, never the target: the next apply overwrites it.
- Read the project instructions of the source repo (AGENTS.md, CLAUDE.md, README) before changing its layout.
- Source names:
  - `dot_` → leading `.`; `private_` → mode 0600/0700; `executable_` → executable bit.
  - `exact_` → removes target files missing from the source; applies only to the directory carrying it, nested directories need their own prefix. Use it only on directories owned entirely by the repo, never on directories other tools or repos write to.
  - `symlink_` → symlink, the file content is the link target.
  - `modify_` → script that reads the current target on stdin and prints the new one (for files the application rewrites, like JSON settings).
  - `run_once_`, `run_onchange_` (in `.chezmoiscripts/`) → scripts; `run_onchange_` reruns when its content changes, so it embeds the hash of the files it depends on.
  - `.tmpl` → Go template; shared snippets live in `.chezmoitemplates/` and are included with `{{ template "name" . }}`.
- `.chezmoiignore` (templated) skips targets per machine, e.g. when a tool is missing (`lookPath`).
- `.chezmoiexternal.toml` downloads external files and archives.

## Applying

1. `chezmoi execute-template < <file>.tmpl` to check a template renders.
2. `chezmoi diff <target>` and check only the expected changes appear.
3. `chezmoi apply <target>`: always name the targets, never a bare `chezmoi apply` without reading the full diff first.
- Target changed outside chezmoi: `chezmoi diff` shows it; bring it into the source with `chezmoi merge <target>` or `chezmoi re-add <target>`, never overwrite it silently.

## Secrets

- Never put secrets in the source. Read them from Bitwarden through templates or helpers; machine-local values go in ignored local files.
- The source repo may be public: no work hosts, emails or internal names.
