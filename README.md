# dotfiles

> [!WARNING]
> I am starting to adopt [`chezmoi`](https://www.chezmoi.io) instead of custom scripts. For this reason, the repository has been reset and [the previous content moved to Codeberg](https://codeberg.org/Kasui92/dotfiles).

## Machine-local Git configuration

The managed Git configuration optionally includes
`~/.config/git/config-local`. This file and any file whose name starts with
`config-local` are intentionally left unmanaged, so they can contain
machine-specific identities and signing settings.

For settings that should apply only to repositories hosted by a specific
provider, use `config-local` as a dispatcher:

```gitconfig
[includeIf "hasconfig:remote.*.url:git@example.com:*/**"]
    path = ~/.config/git/config-local-work

[includeIf "hasconfig:remote.*.url:https://example.com/**"]
    path = ~/.config/git/config-local-work
```

Then put the provider-specific values in the referenced file:

```gitconfig
[user]
    email = user@example.com
    signingkey = KEY_FINGERPRINT

[commit]
    gpgsign = true
```

Missing local files are ignored by Git, so no additional setup is required on
machines that do not need them.
