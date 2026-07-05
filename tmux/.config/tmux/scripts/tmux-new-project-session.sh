#!/usr/bin/env bash
set -euo pipefail

REPOS_DIR="$HOME/repos"
WORKTREES_DIR="$HOME/worktrees"

die() {
    echo "$@" >&2
    read -rp "Press enter to close..."
    exit 1
}

# 1. Pick repo with fzf (filter to git repos: normal or bare)
repo_list=$(
    for d in "$REPOS_DIR"/*/; do
        d="${d%/}"
        name="${d##*/}"
        if [ -d "$d/.git" ] || { [ -f "$d/HEAD" ] && [ -d "$d/refs" ]; }; then
            echo "$name"
        fi
    done
)
[ -z "$repo_list" ] && die "No git repos found under $REPOS_DIR"

repo=$(printf '%s\n' "$repo_list" | fzf --prompt='Repo> ' --layout=reverse --border --height=100%) || exit 0
[ -z "$repo" ] && exit 0
repo_path="$REPOS_DIR/$repo"

# 2. Pick existing branch OR type a new name.
#    Branch list = local + remote (deduped, origin/ prefix stripped, sorted by recency).
branch_list=$(
    git -C "$repo_path" for-each-ref \
        --sort=-committerdate \
        --format='%(refname)' \
        refs/heads refs/remotes \
        | grep -v '/HEAD$' \
        | sed -e 's|^refs/heads/||' -e 's|^refs/remotes/[^/]*/||' \
        | awk '!seen[$0]++'
)

# fzf --print-query: line 1 = typed query, line 2 = selection (empty if none).
# This lets the user either pick an existing branch or type a new name and hit Enter.
fzf_out=$(printf '%s\n' "$branch_list" | fzf \
    --print-query \
    --prompt='Branch> ' \
    --header='Pick existing or type a new branch name, then Enter' \
    --layout=reverse --border --height=100%) || true

query=$(printf '%s\n' "$fzf_out" | sed -n '1p')
selection=$(printf '%s\n' "$fzf_out" | sed -n '2p')

if [ -n "$selection" ]; then
    branch="$selection"
elif [ -n "$query" ]; then
    branch="$query"
else
    exit 0
fi

# Classify branch
local_exists=false
remote_exists=false
if git -C "$repo_path" show-ref --verify --quiet "refs/heads/$branch"; then
    local_exists=true
fi
if git -C "$repo_path" show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    remote_exists=true
fi

# Sanitize for path / session
safe_branch=$(printf '%s' "$branch" | tr '/ .:' '----')
worktree_path="$WORKTREES_DIR/$repo/$safe_branch"
session="${repo}-${safe_branch}"

# 3. If a session already exists → just switch to it. Done.
if tmux has-session -t "=$session" 2>/dev/null; then
    if [ -n "${TMUX:-}" ]; then
        tmux switch-client -t "$session"
    else
        tmux attach-session -t "$session"
    fi
    exit 0
fi

# 4. Determine if we need to create the worktree, and how.
already_in_worktree_list=false
if git -C "$repo_path" worktree list --porcelain | grep -q "^worktree $worktree_path$"; then
    already_in_worktree_list=true
fi

if [ "$already_in_worktree_list" = true ] && [ -d "$worktree_path" ]; then
    : # reuse existing worktree as-is
else
    # Resolve default branch (origin/HEAD, fallback to current HEAD)
    default_branch=$(
        git -C "$repo_path" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null \
            | sed 's|^origin/||'
    ) || default_branch=""
    [ -z "$default_branch" ] && default_branch=$(git -C "$repo_path" rev-parse --abbrev-ref HEAD)

    mkdir -p "$WORKTREES_DIR/$repo"

    if [ "$local_exists" = true ]; then
        # Check out the existing local branch (no -b)
        gwta_args="'$worktree_path' '$branch'"
    elif [ "$remote_exists" = true ]; then
        # Create local tracking branch from remote
        gwta_args="'$worktree_path' -b '$branch' 'origin/$branch'"
    else
        # Brand new branch off default
        gwta_args="'$worktree_path' -b '$branch' '$default_branch'"
    fi

    if ! fish -c "cd '$repo_path'; and gwta $gwta_args"; then
        die "gwta failed"
    fi
fi

# 5. Build tmux session
tmux new-session -d -s "$session" -c "$worktree_path" -n edit
tmux split-window -h -t "$session:1" -c "$worktree_path"
tmux send-keys -t "$session:1.1" 'nvim .' C-m
tmux send-keys -t "$session:1.2" 'claude' C-m
tmux new-window -t "$session" -c "$worktree_path" -n shell
tmux select-window -t "$session:1"
tmux select-pane -t "$session:1.1"

# 6. Attach
if [ -n "${TMUX:-}" ]; then
    tmux switch-client -t "$session"
else
    tmux attach-session -t "$session"
fi
