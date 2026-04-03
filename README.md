# dotfiles

My dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

This repo uses chezmoi source-state naming, so `dot_config/hypr/hyprland.conf`
becomes `~/.config/hypr/hyprland.conf` on the target machine.

## Setup on a new device

```bash
# Install chezmoi
# macOS
brew install chezmoi

# Linux
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"

# Initialize from this repo
chezmoi init https://github.com/nikhil-sharma-b/dotfiles

# Review and apply
chezmoi diff
chezmoi apply
```

## Current layout

Shared configs:

- `dot_config/fish/`
- `dot_config/git/config`
- `dot_config/kitty/kitty.conf`
- `dot_config/lazygit/config.yml`
- `dot_config/nvim/`
- `dot_config/tmux/tmux.conf`

Linux / Omarchy configs:

- `dot_config/hypr/`
- `dot_config/waybar/`

macOS-only configs are not added yet. When you are on your Mac, add them with
`chezmoi add`, for example:

```bash
chezmoi add ~/.config/karabiner/karabiner.json
chezmoi add ~/.claude/settings.json
```

## Workflow

```bash
# Track an existing file
chezmoi add ~/.config/hypr/bindings.conf

# Edit a managed file
chezmoi edit ~/.config/waybar/config.jsonc

# Preview changes
chezmoi diff

# Apply changes
chezmoi apply
```

## Omarchy notes

- Track user-owned config in `~/.config/`.
- Do not track `~/.config/omarchy/current/` or `~/.config/omarchy/themed/`.
- Do not edit anything in `~/.local/share/omarchy/`.
- After changing Waybar config, run `omarchy-restart-waybar`.
- Hyprland usually reloads automatically when its config files change.
