# dotfiles

My dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

This machine is installed with stow-style symlinks such as
`~/.config/fish -> ~/repos/dotfiles/fish/.config/fish`. Keep those package
directories present so existing configs do not become broken symlinks.

The `dot_config/` tree contains chezmoi/Omarchy source-state configs from a
separate Linux setup. It is not used by `install.sh` on this Mac.

## Setup on a new device

```bash
# 1. Install stow
# macOS
brew install stow

# Debian/Ubuntu
sudo apt install stow

# 2. Clone and install
git clone https://github.com/nikhil-sharma-b/dotfiles ~/repos/dotfiles
cd ~/repos/dotfiles
./install.sh
```

The install script auto-detects the OS and stows the right packages.

## Packages

| Package   | What                 | Devices |
|-----------|----------------------|---------|
| git       | `.gitconfig`         | all     |
| fish      | Fish shell config    | all     |
| zsh       | Zsh config           | all     |
| tmux      | Tmux config          | all     |
| nvim      | Neovim config        | all     |
| lazygit   | Lazygit config       | all     |
| kitty     | Kitty terminal       | all     |
| ohmyposh  | Oh My Posh theme     | all     |
| claude    | Claude Code settings | macOS   |
| karabiner | Karabiner-Elements   | macOS   |
| kanata    | Kanata config        | macOS   |

## Manual stowing

```bash
cd ~/repos/dotfiles
stow -t "$HOME" <package>       # install
stow -t "$HOME" -D <package>    # uninstall
```
