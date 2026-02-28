# dotfiles > Omabuntu

Configuration for [Omadeb](https://omadeb.omakasui.org) (Debian + GNOME)

## Installation

### Using the dotfiles command (Recommended)

If you've already set up the dotfiles command via the bootstrap script:

```bash
dotfiles install omabuntu
```

### Manual Installation

1. Clone this repository into your home directory, using `.cfg` as the folder name:

   ```bash
   git clone <repo-url> ~/.cfg
   ```

2. Run the following instalation script:

   ```bash
   if [ -f ~/.bashrc ]; then
      echo "source ~/.cfg/omabuntu/default/bash/rc" >> ~/.bashrc
      echo "export PATH=\"\$HOME/.cfg/omabuntu/bin:\$PATH\"" >> ~/.bashrc
   fi

   cp -r ~/.cfg/shared/config/* ~/.config/
   cp -r ~/.cfg/omabuntu/config/* ~/.config/
   ```

This will set up your environment with the provided configurations.

## Directory Structure

```
omabuntu/
├── applications/  # Custom applications install/remove scripts
├── bin/           # Custom utility commands
├── config/        # Application configurations
├── default/       # Default configurations and scripts
|   └── bash/      # Bash configuration files
└── install        # Installation script
```
