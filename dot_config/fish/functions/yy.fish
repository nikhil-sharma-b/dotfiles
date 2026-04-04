function yy
    set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"

    if set -l cwd (command cat -- "$tmp")
        if test -n "$cwd" -a "$cwd" != "$PWD"
            cd -- "$cwd"
        end
    end

    command rm -f -- "$tmp"
end
