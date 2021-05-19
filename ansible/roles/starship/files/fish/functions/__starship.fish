function __starship
    status is-interactive
    and command -sq starship
    and starship init fish | source
end
