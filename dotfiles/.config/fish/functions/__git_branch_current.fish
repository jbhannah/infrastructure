function __git_branch_current
    set -l ref (git symbolic-ref HEAD 2> /dev/null)

    test -n "$ref"
    and echo (string replace "refs/heads/" "" $ref)
end
