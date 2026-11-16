# Dotfiles

Personal dotfiles managed by chezmoi, public on Codeberg. Ubuntu, niri + DMS, Alacritty, zellij, Neovim 0.12, bash. Rosé Pine everywhere.

## Layout

- `.chezmoiroot` points at `home/`: the repo root holds only README, images, `.githooks/`, `.gitleaks.toml` and this file, none of them applied.
- `home/.chezmoiscripts/`: `run_onchange_*` scripts embed the hash of the file they depend on (mise config, fonts, zen user.js), `run_once_after_git-hooks` points git at `.githooks/`.
- `home/.chezmoitemplates/zellij/`: keybinds and plugins, included by `dot_config/zellij/config.kdl.tmpl`.
- `home/.chezmoiexternal.toml`: zellij plugin wasm files (zjstatus fork, vim-zellij-navigator, zellij-forgot, zellij-sessionizer).
- `home/dot_config/exact_nvim/`: native config, `vim.pack` plugin list in `lua/kasui92/plugins/init.lua`, one module per area in `lua/kasui92/plugins/`, helpers on the `Kasui92` global (`lua/kasui92/utils/`), server settings in `after/lsp/<server>.lua`.
- `home/dot_config/bash/`: `rc` sources `envs` (`env/*`), `aliases` (`als/*`), `functions` (`fns/*`), `prompt`, `init` (mise, zoxide, fzf).

## chezmoi rules

- Edit the source, then `chezmoi diff` and `chezmoi apply <target>`.
- `exact_` applies only to the directory carrying it: every nested nvim directory needs its own prefix.
- Never make `~/.local/bin`, `~/.ssh` or `~/.config/git` `exact_`: other repos write there.
- Ignored on purpose: `nvim-pack-lock.json` and `lua/kasui92/plugins/local.lua` (machine-local plugins), machine-local files listed in the README.
- Work config lives in a separate chezmoi repo (`cmw`): no work hosts, emails or includes here. This repo exposes only generic hooks (`~/.gitconfig`, `~/.ssh/config.d/*`, `gpg-*` Bitwarden items).
- Secrets come from Bitwarden (`bwu`), never from the repo. The pre-commit hook runs gitleaks.

## Keys

Each layer owns its keys:

- niri: Super.
- zellij: Alt for direct actions, `Ctrl g` opens the mode menu, default mode is locked. `Alt hjkl` moves across zellij panes and nvim splits (vim-zellij-navigator + zellij-nav.nvim).
- Neovim, modelled on craftzdog's dotfiles (github.com/craftzdog/dotfiles); state any divergence from it:
  - vim grammar for motions: `g`, `[`/`]`, text objects.
  - `;` pickers (Snacks), plus `;g` lazygit; `\\` buffers.
  - `s` windows and oil: `ss` `sv` split, `sf` `sF` oil.
  - `<leader>` + area for actions: `c` code, `g` git, `d` codediff, `y` yank, `u` toggles, `q` session, `a` Claude, `b` buffers, `<tab>` tabpages.
  - Divergence: mini.clue on `<Leader>` and `;` waits for the next key and shows their menus (group names in `plugins/ui.lua`, buffer groups via `vim.b.miniclue_config`); `;` alone is `;<CR>`. Other prefixes keep craftz's 500 ms `timeoutlen`.
  - Pickers keep the Snacks keys (`<C-v>` vsplit, `<C-s>` split, `<C-t>` tab); in oil `<C-s>` saves and `<C-v>` opens a vsplit.
  - No Alt keys that zellij binds; see `home/.chezmoitemplates/zellij/keybinds.kdl`.

## Project services in zellij

`zs` (bash, inside zellij) opens a "services" tab from `<git root>/.zellij/services.kdl`. Layouts belong to the project or to `cmw`, not here:

```kdl
layout {
    tab name="services" {
        pane size=1 borderless=true {
            plugin location="zjstatus"
        }
        pane split_direction="vertical" {
            pane name="dev" command="bash" start_suspended=true {
                args "-ic" "npm run dev"
            }
            pane name="test" command="bash" start_suspended=true {
                args "-ic" "npm test -- --watch"
            }
        }
    }
}
```

## Checks

- nvim: `nvim --headless +qa` starts without messages.
- zellij: `zellij setup --check` reports the config as well defined.
- Secrets: `gitleaks git` on the whole history.
