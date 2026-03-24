# dotfiles

My configs, managed with [GNU Stow](https://www.gnu.org/software/stow/).

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

| Package    | What                        | Devices |
|------------|-----------------------------|---------|
| git        | `.gitconfig`                | all     |
| fish       | Fish shell config           | all     |
| zsh        | Zsh config                  | all     |
| tmux       | Tmux config                 | all     |
| nvim       | Neovim (LazyVim)            | all     |
| lazygit    | Lazygit config              | all     |
| kitty      | Kitty terminal              | all     |
| claude     | Claude Code settings        | macOS   |
| karabiner  | Karabiner-Elements          | macOS   |
| kanata     | Kanata keyboard remapper    | macOS   |

## Manual stowing

To stow individual packages:

```bash
cd ~/repos/dotfiles
stow -t ~ <package>       # install
stow -t ~ -D <package>    # uninstall
```
