command -sq go
and test -d $HOME/Code
and set -gx GOPATH $HOME/Code

test -d $GOPATH/bin
and fish_add_path $GOPATH/bin
