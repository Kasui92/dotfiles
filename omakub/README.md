# dotfiles > Omakub

Configuration for [Omakub](https://omakub.org) and [Omakube](https://github.com/Kasui92/omakube) (my personal Omakub fork)

## Installation

### Using the dotfiles command (Recommended)

If you've already set up the dotfiles command via the bootstrap script:

```bash
dotfiles install omakub
```

### Manual Installation

1. Clone this repository into your home directory, using `.cfg` as the folder name:

   ```bash
   git clone <repo-url> ~/.cfg
   ```

2. Run the installation script using `source`:

   ```bash
   source ~/.cfg/omakub/install
   ```

This will set up your environment with the provided configurations.

## Directory Structure

```
omakasui/
├── bin/           # Custom utility commands
├── config/        # Application configurations
├── default/       # Default configurations and scripts
|   └── bash/      # Bash configuration files
|   └── systemd/   # Systemd confs
└── install        # Installation script
```
