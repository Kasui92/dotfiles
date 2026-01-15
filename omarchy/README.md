# dotfiles > Omarchy

Configuration for [Omarchy](https://omarchy.org) (Arch + Hyprland)

## Installation

### Using the dotfiles command (Recommended)

If you've already set up the dotfiles command via the bootstrap script:

```bash
dotfiles install omarchy
```

### Manual Installation

1. Clone this repository into your home directory, using `.cfg` as the folder name:

   ```bash
   git clone <repo-url> ~/.cfg
   ```

2. Run the installation script using `source`:

   ```bash
   source ~/.cfg/omarchy/install.sh
   ```

This will set up your environment with the provided configurations.

## Directory Structure

```
omarchy/
├── bin/           # Custom utility commands
├── config/        # Application configurations
├── default/       # Default configurations and scripts
|   └── bash/      # Bash configuration files
└── install        # Installation script
```
