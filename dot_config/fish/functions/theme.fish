function theme --description "Select a Ghostty theme and sync terminal tools"
    ghostty +list-themes
    or return

    theme-sync
    or return

    set -l theme_env "$HOME/.config/theme-sync/generated/fish.fish"
    test -r "$theme_env"; and source "$theme_env"
end
