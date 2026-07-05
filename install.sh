#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES"

if ! command -v stow >/dev/null 2>&1; then
    echo "GNU Stow is required. Install it first, then rerun ./install.sh." >&2
    exit 1
fi

# Shared packages used on all personal machines.
SHARED=(git fish zsh tmux nvim lazygit kitty ohmyposh)

# macOS-only packages.
MACOS=(karabiner kanata claude)

# Linux-only packages. Keep empty until Linux stow packages are added.
LINUX=()

echo "Stowing shared packages..."
stow -t "$HOME" "${SHARED[@]}"

case "$(uname)" in
    Darwin)
        echo "Stowing macOS packages..."
        stow -t "$HOME" "${MACOS[@]}"
        ;;
    Linux)
        if [ "${#LINUX[@]}" -gt 0 ]; then
            echo "Stowing Linux packages..."
            stow -t "$HOME" "${LINUX[@]}"
        fi
        ;;
esac

echo "Done. Configs are symlinked from $DOTFILES."
