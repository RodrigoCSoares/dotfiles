#!/bin/bash
set -e

# Dotfiles bootstrap script
# Run this on a fresh machine to restore your development environment
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/RodrigoCSoares/dotfiles/main/.dotfiles-install.sh | bash
#   OR
#   bash .dotfiles-install.sh

DOTFILES_REPO="git@github.com:RodrigoCSoares/dotfiles.git"
NVIM_REPO="git@github.com:RodrigoCSoares/nvim-config.git"
SCRIPTS_REPO="git@github.com:RodrigoCSoares/scripts.git"

echo "==> Starting dotfiles installation..."

# Install Xcode Command Line Tools if not present
if ! xcode-select -p &>/dev/null; then
    echo "==> Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Please complete the Xcode CLI tools installation and re-run this script."
    exit 1
fi

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Clone dotfiles bare repo
if [ ! -d "$HOME/.dotfiles" ]; then
    echo "==> Cloning dotfiles repository..."
    git clone --bare "$DOTFILES_REPO" "$HOME/.dotfiles"
fi

# Define dotfiles alias for this script
dotfiles() {
    git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

# Backup existing dotfiles if they exist
echo "==> Backing up existing dotfiles..."
mkdir -p "$HOME/.dotfiles-backup"
dotfiles checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | while read -r file; do
    if [ -f "$HOME/$file" ]; then
        mkdir -p "$HOME/.dotfiles-backup/$(dirname "$file")"
        mv "$HOME/$file" "$HOME/.dotfiles-backup/$file"
        echo "    Backed up: $file"
    fi
done

# Checkout dotfiles
echo "==> Checking out dotfiles..."
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no

# Install Homebrew packages
if [ -f "$HOME/.Brewfile" ]; then
    echo "==> Installing Homebrew packages from Brewfile..."
    brew bundle --file="$HOME/.Brewfile"
fi

# Install oh-my-zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "==> Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "==> Installing powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# Install zsh-autosuggestions plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "==> Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi

# Clone neovim config
if [ ! -d "$HOME/.config/nvim" ]; then
    echo "==> Cloning neovim config..."
    mkdir -p "$HOME/.config"
    git clone "$NVIM_REPO" "$HOME/.config/nvim"
fi

# Clone personal scripts
if [ ! -d "$HOME/personal/scripts" ]; then
    echo "==> Cloning personal scripts..."
    mkdir -p "$HOME/personal"
    git clone "$SCRIPTS_REPO" "$HOME/personal/scripts"
fi

echo ""
echo "==> Dotfiles installation complete!"
echo ""
echo "Next steps:"
echo "  1. Create ~/.secrets file with your API tokens (e.g., JIRA_API_TOKEN)"
echo "  2. Restart your terminal or run: source ~/.zshrc"
echo ""
echo "To manage dotfiles, use the 'dotfiles' alias:"
echo "  dotfiles status"
echo "  dotfiles add ~/.some-config"
echo "  dotfiles commit -m 'message'"
echo "  dotfiles push"
