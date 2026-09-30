# dotfiles

> [!WARNING]
> I am starting to adopt [`chezmoi`](https://www.chezmoi.io) instead of custom scripts. For this reason, the repository has been reset and [the previous content moved to Codeberg](https://codeberg.org/Kasui92/dotfiles).

## Machine-local configuration

These files are ignored by chezmoi and optional. Create them only where needed.

| File | Purpose |
| --- | --- |
| `~/.bashrc.local` | Extra shell config, sourced last by `~/.bashrc` |
| `~/.config/git/config-local*` | Identities, signing keys, per-provider settings |
| `~/.config/niri/config/outputs.kdl` | Monitor layout for niri |
| `~/.config/niri/dms/outputs.kdl` | Monitor layout for niri with DMS |

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

### niri outputs

Get output names and modes with `niri msg outputs`, then:

```kdl
output "eDP-1" {
    mode "2560x1600@240"
    position x=0 y=0
}
```
