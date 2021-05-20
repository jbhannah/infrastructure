if command -sq exa
    function ls --wraps='exa'
        exa --group-directories-first $argv
    end
end
