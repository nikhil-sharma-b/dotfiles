if status is-interactive
    # Commands to run in interactive sessions can go here
end

# ── Abbreviations (expand inline, visible in history) ──────────────
abbr -a c clear
abbr -a q exit
abbr -a lg lazygit
abbr -a x exit
abbr -a sv "sudo nvim"
abbr -a fm yazi
abbr -a zz "cd -"
abbr -a s "kitten ssh"
abbr -a j just
abbr -a ta "tmux a -t"
abbr -a tn "tmux new -t"
abbr -a tl "tmux ls"

# ── Aliases ────────────────────────────────────────────────────────
alias vim="nvim"
alias cat="bat --style=numbers --paging=never"
alias claude="$HOME/.claude/local/claude"
alias cc="$HOME/.claude/local/claude --dangerously-skip-permissions --plugin-dir ~/.claude/plugins/codex-commit"
alias co="codex --dangerously-bypass-approvals-and-sandbox"

# ── Environment Variables ──────────────────────────────────────────
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx GIT_EDITOR nvim
set -gx GPG_TTY (tty)
set fish_greeting ""

# FZF theming (Catppuccin Mocha)
set -gx FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--height=20 \
--reverse \
--bind 'change:first' \
--multi"

# Bun
set -gx BUN_INSTALL "$HOME/.bun"

# ── PATH ───────────────────────────────────────────────────────────
# Homebrew (must be early)
fish_add_path /opt/homebrew/bin

# User tools
fish_add_path $HOME/.claude/local
fish_add_path $BUN_INSTALL/bin
fish_add_path $HOME/Library/Python/3.9/bin
fish_add_path $HOME/.console-ninja/.bin
fish_add_path $HOME/.lmstudio/bin
fish_add_path /Applications/Windsurf.app/Contents/Resources/app/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/scripts
fish_add_path $HOME/.local/bin
fish_add_path /usr/local/bin

# ── Key Bindings (vi mode) ────────────────────────────────────────
set -g fish_key_bindings fish_vi_key_bindings
set -g fish_vi_force_cursor 1

# Cursor shapes (emulates vim)
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_replace underscore
set fish_cursor_external line
set fish_cursor_visual block

# Custom bindings
bind --mode insert \cf forward-char
bind --mode insert \cy forward-char
bind --mode default --mode insert \cp history-search-backward
bind --mode default --mode insert \cn history-search-forward

# ── Initializations ───────────────────────────────────────────────
# fnm (Node version manager)
if type -q fnm
    fnm env --use-on-cd --shell fish | source
    # Ensure tools from the active fnm Node install (like codex) are available.
    if not type -q codex
        fnm use default >/dev/null 2>&1
    end
end

# zoxide (smart cd)
if type -q zoxide
    zoxide init --cmd cd fish | source
end

# oh-my-posh prompt
if type -q oh-my-posh
    oh-my-posh init fish --config "$HOME/.config/ohmyposh/base.toml" | source
end

# langflow uv env
if test -e "$HOME/.langflow/uv/env.fish"
    source "$HOME/.langflow/uv/env.fish"
end

# bun completions
if test -e "$HOME/.bun/_bun.fish"
    source "$HOME/.bun/_bun.fish"
end

# ── Functions ──────────────────────────────────────────────────────

# yazi file manager with cwd sync
function yy
    if not type -q yazi
        return 1
    end
    set -l tmp (mktemp -t yazi-cwd.XXXXXX)
    yazi --cwd-file="$tmp" $argv
    set -l cwd (cat -- "$tmp")
    if test -n "$cwd" -a "$cwd" != "$PWD"
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# Kanata keyboard remapper
function kn -d "Start kanata keyboard remapper"
    sudo pkill -9 kanata-bin 2>/dev/null
    sudo /Applications/Kanata.app/Contents/MacOS/kanata-bin -c ~/.config/kanata/config.kbd &>/dev/null &
    disown
    echo "Kanata started"
end

function knx -d "Stop kanata keyboard remapper"
    sudo pkill -9 kanata-bin 2>/dev/null; and echo "Kanata stopped"; or echo "Kanata not running"
end

# Git worktree add with env symlinks
function gwta -d "git worktree add + symlink envs from bare repo"
    if test (count $argv) -lt 1
        echo "Usage: gwta <path> [branch]"
        return 1
    end

    git worktree add $argv
    or return 1

    set -l wt_path $argv[1]

    # Find the bare repo's git dir
    set -l git_common (git -C $wt_path rev-parse --git-common-dir 2>/dev/null)
    if test -z "$git_common"
        return 0
    end

    set -l envs_dir "$git_common/envs"
    if not test -d "$envs_dir"
        echo "No envs dir found at $envs_dir — skipping symlinks"
        return 0
    end

    for f in $envs_dir/*
        set -l fname (basename $f)
        ln -sf $f $wt_path/$fname
        echo "Linked $fname"
    end
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# opencode
fish_add_path $HOME/.opencode/bin
