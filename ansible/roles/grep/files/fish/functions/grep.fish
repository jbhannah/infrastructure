if type -q ggrep
    function grep --wraps='ggrep'
        ggrep --color=auto $argv
    end
end
