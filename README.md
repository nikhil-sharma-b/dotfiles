# dotfiles

Personal Linux and macOS configuration managed by
[chezmoi](https://www.chezmoi.io/).

## Install

Install chezmoi first:

```bash
# macOS
brew install chezmoi

# Arch Linux
sudo pacman -S chezmoi
```

Initialize with the canonical source location, preview, then apply:

```bash
chezmoi --source "$HOME/repos/dotfiles" init \
  https://github.com/nikhil-sharma-b/dotfiles.git
chezmoi doctor
chezmoi diff
chezmoi apply
```

For an existing clone:

```bash
chezmoi --source "$HOME/repos/dotfiles" init
```

## Layout

Shared configuration lives under `dot_config/`. Full Fish, Kitty, Tmux, and
Kanata variants live in `.chezmoitemplates/` and are selected by OS.

Linux-only configuration:

- Hyprland and Waybar
- systemd user units
- Omarchy-safe user configuration

macOS-only configuration:

- AeroSpace and Karabiner
- Claude settings and skill links
- Zsh and macOS Kanata files

Machine-generated state, backups, Tmux plugins, and Omarchy runtime theme
links are excluded.

## Workflow

```bash
# See source path and managed files
chezmoi source-path
chezmoi managed

# Import a changed live file
chezmoi re-add ~/.config/nvim/init.lua

# Edit through chezmoi
chezmoi edit ~/.config/tmux/tmux.conf

# Review and apply
chezmoi diff
chezmoi apply
```

Do not edit `~/.local/share/omarchy/`. Track only user-owned configuration.
After Hyprland changes, run `hyprctl reload` and `hyprctl configerrors`. After
Waybar changes, run `omarchy restart waybar`.
