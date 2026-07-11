fish_add_path "$HOME/.cargo/bin"

if status is-interactive
    # Commands to run in interactive sessions can go here
    alias c="clear"
    alias oc="opencode"
    alias lg="lazygit"
    alias q="exit"
    alias cc="claude --dangerously-skip-permissions"

    abbr -a tl "tmux ls"
    abbr -a ta "tmux a -t"
    abbr -a tn "tmux new -s"

    source ~/.config/fish/functions/yy.fish
end
export PATH="$HOME/.local/bin:$PATH"
