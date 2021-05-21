if test -d $HOME/Code
    set -gx GOPATH $HOME/Code
    fish_add_path $GOPATH/bin
end
