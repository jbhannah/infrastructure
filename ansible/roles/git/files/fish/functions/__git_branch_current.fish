function __git_branch_current
    git rev-parse

    set -l ref (git symbolic-ref HEAD 2> /dev/null)

    test -n "$ref"
    and echo (string replace "refs/heads/" "" $ref)
end
