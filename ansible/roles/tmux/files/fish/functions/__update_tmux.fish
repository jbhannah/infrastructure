function __update_tmux
    git -C ~/.tmux pull --rebase=false origin master >/dev/null 2>&1 &
end
