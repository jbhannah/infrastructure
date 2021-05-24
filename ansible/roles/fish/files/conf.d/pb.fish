if status is-interactive
    command -sq pbcopy
    and abbr -a -g pbc pbcopy

    command -sq pbpaste
    and abbr -a -g pbp pbpaste
end
