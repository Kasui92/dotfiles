# dotfiles > Omakasui

Omakasui configuration for Hyprland-based desktop environments.

## Installation

### Using the dotfiles command (Recommended)

If you've already set up the dotfiles command via the bootstrap script:

```bash
dotfiles install omakasui
```

### Manual Installation

1. Clone this repository into your home directory, using `.cfg` as the folder name:

   ```bash
   git clone <repo-url> ~/.cfg
   ```

2. Run the installation script using `source`:

   ```bash
   source ~/.cfg/omakasui/install
   ```

This will set up your environment with the provided configurations.

## Directory Structure

```
omakasui/
├── bin/           # Custom utility commands
├── config/        # Application configurations
│   ├── hypr/      # Hyprland configuration
│   └── starship.toml
├── default/       # Default configurations and scripts
|   └── bash/      # Bash configuration files
└── install        # Installation script
```
