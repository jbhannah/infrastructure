status is-interactive
and not set -q TMUX
and exec tmux new-session -A -s fish
