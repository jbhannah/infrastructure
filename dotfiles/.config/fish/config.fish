status is-interactive
and set -g fish_greeting

abbr -ag l ls -alh

set -q VISUAL
or set -gx VISUAL vim

set -gx EDITOR $VISUAL
