test -d $HOME/.krew/bin
and fish_add_path $HOME/.krew/bin

set -l local_kubeconfig (mktemp -t "kubectl")
set -gx KUBECONFIG "$local_kubeconfig:$HOME/.kube/config"
echo "\
apiVersion: v1
kind: Config
current-context: \"\"
" >$local_kubeconfig
