if status is-interactive; and not set -q TMUX
    __update_tmux
    exec tmux new-session -A -s fish
end
