#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES"

# Shared packages (all devices)
SHARED="git fish zsh tmux nvim lazygit kitty ohmyposh"

# macOS-only packages
MACOS="karabiner kanata claude"

# Linux-only packages
LINUX=""

echo "Stowing shared packages..."
stow -t ~ $SHARED

case "$(uname)" in
    Darwin)
        echo "Stowing macOS packages..."
        stow -t ~ $MACOS
        ;;
    Linux)
        if [ -n "$LINUX" ]; then
            echo "Stowing Linux packages..."
            stow -t ~ $LINUX
        fi
        ;;
esac

echo "Done! All configs symlinked."
