# dotfiles

> What are we, if not the sum of our dotfiles?

My personal dotfiles are managed entirely through [chezmoi](https://www.chezmoi.io).

## Machine-local configuration

These files are ignored by chezmoi and optional. Create them only where needed.

| File | Purpose |
| --- | --- |
| `~/.bashrc.local` | Extra shell config, sourced last by `~/.bashrc` |
| `~/.config/git/config-local*` | Identities, signing keys, per-provider settings |
| `~/.config/niri/config/outputs.kdl` | Monitor layout for niri |
| `~/.config/niri/dms/outputs.kdl` | Monitor layout for niri with DMS |
| `~/.ssh/config` | SSH hosts |

### Git

`~/.config/git/config-local` is included by the managed config. Use it as a
dispatcher for per-provider settings:

```gitconfig
[includeIf "hasconfig:remote.*.url:git@example.com:*/**"]
    path = ~/.config/git/config-local-work
```

```gitconfig
# ~/.config/git/config-local-work
[user]
    email = user@example.com
    signingkey = KEY_FINGERPRINT

[commit]
    gpgsign = true
```

## Bitwarden

With `bitwarden.enabled`, SSH and GPG keys come from the Bitwarden vault via `bw`.

| Item | Type | Content |
| --- | --- | --- |
| any name | SSH key | Private key, loaded by `bwu` |
| `gpg-github`, `gpg-gitlab`, `gpg-codeberg`, `gpg-work` | Secure note | Notes: output of `gpg --export-secret-keys --armor <FPR>` |
| same `gpg-*` items | Hidden custom field `passphrase` | Key passphrase, preset into gpg-agent by `bwu` |

Fingerprints are mapped in `home/.chezmoidata/gpg.toml`. Missing GPG keys are
imported by `chezmoi apply`.

- `bwu`: unlock the vault, load SSH keys and GPG passphrases, lock the vault again.
- `bwl`: lock the vault, clear the SSH agent and the GPG passphrase cache.
