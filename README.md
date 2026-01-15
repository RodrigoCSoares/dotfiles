# Dotfiles

My personal development environment configuration, managed with a [bare git repository](https://www.atlassian.com/git/tutorials/dotfiles).

## What's Included

| File/Directory | Purpose |
|----------------|---------|
| `.zshrc`, `.zprofile`, `.zshenv` | Zsh shell configuration |
| `.p10k.zsh` | Powerlevel10k prompt theme |
| `.gitconfig` | Git configuration |
| `.Brewfile` | Homebrew packages (formulae + casks) |
| `.config/ghostty/` | Ghostty terminal config |
| `.config/btop/` | btop system monitor config |
| `.config/gh/` | GitHub CLI config |
| `.dotfiles-install.sh` | Bootstrap script for new machines |

Neovim config is in a separate repo: [nvim-config](https://github.com/RodrigoCSoares/nvim-config)

Personal scripts are in a separate repo: [scripts](https://github.com/RodrigoCSoares/scripts)

## Fresh Machine Setup

```bash
curl -fsSL https://raw.githubusercontent.com/RodrigoCSoares/dotfiles/main/.dotfiles-install.sh | bash
```

This will:
1. Install Xcode CLI tools (if needed)
2. Install Homebrew (if needed)
3. Clone this repo as a bare repository to `~/.dotfiles`
4. Checkout all config files to their proper locations
5. Install all Homebrew packages from `.Brewfile`
6. Install oh-my-zsh with powerlevel10k theme and zsh-autosuggestions
7. Clone neovim config to `~/.config/nvim`
8. Clone personal scripts to `~/personal/scripts`

After installation, create `~/.secrets` for API tokens:
```bash
# ~/.secrets
export JIRA_API_TOKEN="your-token-here"
```

## Daily Usage

The `dotfiles` alias is configured in `.zshrc`:

```bash
# Check status
dotfiles status

# Add a new/changed config
dotfiles add ~/.some-config

# Commit and push
dotfiles commit -m "update config"
dotfiles push

# Pull updates on another machine
dotfiles pull
```

## How It Works

This uses a **bare git repository** stored at `~/.dotfiles/` with the work tree set to `$HOME`. This approach:

- Keeps config files in their original locations (no symlinks)
- Hides untracked files by default (won't show your entire home dir)
- Works like normal git with the `dotfiles` alias

The alias is defined as:
```bash
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

## Updating Brewfile

After installing/removing packages, regenerate the Brewfile:

```bash
brew bundle dump --file=~/.Brewfile --force
dotfiles add ~/.Brewfile
dotfiles commit -m "update Brewfile"
dotfiles push
```
