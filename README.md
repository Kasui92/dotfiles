# dotfiles

This repository provides a modular dotfiles setup.

## Installation

The **recommended approach** is to clone this repository into a `.cfg` directory in your HOME folder. This approach ensures all installer scripts and configurations work correctly without requiring path modifications.

### Automatic Installation (Recommended)

For a quick and guided installation using the recommended approach:

```bash
curl -fsSL https://omakasui.org/dotfiles | bash
```

This script will automatically clone the repository to `~/.cfg` and guide you through the installation process.

### Manual Installation

If you prefer to install manually or want to use a different approach, keep in mind that you'll need to update the references within the installer scripts accordingly.

## Configurations

You can then install the desired configuration using the provided scripts.

- **deb**: For Debian/Ubuntu systems. See [deb/README.md](deb/README.md) for details.
- **omakasui**: For Omakase installation. See [omakasui/README.md](omakasui/README.md) for details.

Refer to the documentation in each directory for specific instructions.
