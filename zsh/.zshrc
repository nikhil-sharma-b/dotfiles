
# fnm
FNM_PATH="/Users/nikhilsharma/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/Users/nikhilsharma/Library/Application Support/fnm:$PATH"
  eval "`fnm env`"
fi
eval "$(fnm env --use-on-cd --shell zsh)"
export PATH="$PATH:$HOME/Library/Python/3.9/bin"

PATH=~/.console-ninja/.bin:$PATH
# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/nikhilsharma/.lmstudio/bin"

. "$HOME/.langflow/uv/env"

# bun completions
[ -s "/Users/nikhilsharma/.bun/_bun" ] && source "/Users/nikhilsharma/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias claude="/Users/nikhilsharma/.claude/local/claude"
alias cc="/Users/nikhilsharma/.claude/local/claude --dangerously-skip-permissions --plugin-dir ~/.claude/plugins/codex-commit"
alias co="codex --dangerously-bypass-approvals-and-sandbox"
export PATH="/Applications/Windsurf.app/Contents/Resources/app/bin:$PATH"

# lazygit alias
alias lg="lazygit"

# oh-my-posh prompt
if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config "$HOME/.config/ohmyposh/base.toml")"
fi

# zoxide (smart cd)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd="z"
fi

# yazi (file manager with cwd sync)
function yy() {
  if ! command -v yazi >/dev/null 2>&1; then
    return 1
  fi

  local tmp
  tmp="$(mktemp -t yazi-cwd.XXXXXX)" || return 1
  yazi --cwd-file="$tmp" "$@"

  local cwd
  cwd="$(command cat -- "$tmp")"
  if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Kanata keyboard remapper (kn = start, knx = stop)
kn() {
  sudo pkill -9 kanata-bin 2>/dev/null
  sudo /Applications/Kanata.app/Contents/MacOS/kanata-bin -c ~/.config/kanata/config.kbd &>/dev/null &
  disown
  echo "Kanata started"
}

knx() {
  sudo pkill -9 kanata-bin 2>/dev/null && echo "Kanata stopped" || echo "Kanata not running"
}

# short aliases
alias c="clear"
alias q="exit"
