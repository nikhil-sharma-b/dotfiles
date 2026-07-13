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

## macOS terminal themes

Run `theme` from Fish to open Ghostty's theme preview. Press `Enter` on the
highlighted theme, then press `w` to save and exit the preview. The wrapper
generates matching colors for Kitty, Neovim, LazyGit, Yazi, Tmux, fzf, and
bat.

Use a theme non-interactively with:

```bash
theme-sync "Catppuccin Mocha"
```

Tmux reloads automatically when its server is running. Neovim watches its
generated colorscheme. Reload Ghostty with `Cmd+Shift+,`; restart open Kitty,
LazyGit, and Yazi instances. Generated runtime files live under
`~/.config/theme-sync/` and are not managed by chezmoi.
