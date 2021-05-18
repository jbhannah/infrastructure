if status is-interactive
    set -g fish_greeting

    set -g fish_key_bindings fish_vi_key_bindings
    set -g fish_vi_force_cursor 1
    set -g fish_cursor_default block
    set -g fish_cursor_insert line
    set -g fish_cursor_replace_one underscore

    abbr -ag l ls -alh
end

set -q VISUAL
or set -gx VISUAL vim

set -gx EDITOR $VISUAL

__starship
