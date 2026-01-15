# dotfiles > Debian/Ubuntu

Configuration for Debian-based systems (Debian, Ubuntu, and derivatives).

## Installation

### Using the dotfiles command (Recommended)

If you've already set up the dotfiles command via the bootstrap script:

```bash
dotfiles install deb
```

### Manual Installation

1. Clone this repository into your home directory, using `.cfg` as the folder name:

   ```bash
   git clone <repo-url> ~/.cfg
   ```

2. Run the installation script using `source`:

   ```bash
   source ~/.cfg/deb/install.sh
   ```

This will set up your environment with the provided configurations.

## Optional Installers

The `installer/` directory contains scripts to install various development tools:

- `base.sh`: Essential base packages and utilities
- `docker.sh`: Docker and Docker Compose installation
- `fastfetch.sh`: Fastfetch system information tool
- `gh.sh`: GitHub CLI
- `glab.sh`: GitLab CLI
- `lazygit.sh`: Terminal UI for git
- `mise.sh`: Polyglot runtime manager (formerly rtx)
- `nvim.sh`: Neovim installation

These installers can be run individually as needed after the main installation.

## Directory Structure

```
deb/
├── applications/  # Custom applications install/remove scripts
├── default/       # Default configurations and scripts
|   └── bash/      # Bash configuration files
├── config/        # Application configurations
├── installer/     # Optional tool installers
└── install        # Main installation scripts
```
