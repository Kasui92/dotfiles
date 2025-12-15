# dotfiles

This repository provides a modular dotfiles setup with an easy-to-use command-line interface.

## Installation

The **recommended approach** is to clone this repository into a `.cfg` directory in your HOME folder. This approach ensures all installer scripts and configurations work correctly without requiring path modifications.

### Automatic Installation (Recommended)

For a quick and guided installation using the recommended approach:

```bash
curl -fsSL https://omakasui.org/dotfiles | bash
```

This script will automatically:

- Clone the repository to `~/.cfg`
- Create the `dotfiles` command in `~/.local/bin`
- Set up everything you need to manage your configurations

### Manual Installation

If you prefer to install manually:

```bash
# Clone the repository
git clone https://github.com/Kasui92/dotfiles.git ~/.cfg

# Run the bootstrap script
bash ~/.cfg/boot.sh
```

The bootstrap script will set up the `dotfiles` command for you.

## Using the dotfiles Command

Once installed, you can use the `dotfiles` command to manage your configurations:

```bash
# Show help and available commands
dotfiles help

# List all available configurations
dotfiles list

# Install a configuration interactively
dotfiles install

# Install a specific configuration directly
dotfiles install deb
dotfiles install omakub
dotfiles install omarchy

# Update dotfiles repository from git
dotfiles update
```

**Note:** Make sure `~/.local/bin` is in your PATH. If not, add this line to your `~/.bashrc` or `~/.zshrc`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Available Configurations

- **deb**: For Debian/Ubuntu systems. See [deb/README.md](deb/README.md) for details.
- **omakub**: For Omakub/Omakube installation. See [omakub/README.md](omakub/README.md) for details.
- **omarchy**: For Omarchy installation. See [omarchy/README.md](omarchy/README.md) for details.

Refer to the documentation in each directory for specific instructions.
