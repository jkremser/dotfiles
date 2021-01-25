k8s-all-pod-logs(){
  local _pods=`kubectl get pods -lapp=$(kubectl config view --minify --output 'jsonpath={..namespace}') -o name 2> /dev/null | tr '\n' ' '`
  sp2 kpl ${=_pods}
}
