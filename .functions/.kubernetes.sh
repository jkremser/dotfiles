#!/usr/bin/env bash

wait_for_svc() {
  ip=""
  echo "Waiting for external IP"
  while [ -z $ip ]; do
    printf "."
    ip=$(kubectl get svc $@ --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
    [ -z "$ip" ] && sleep 3
  done
  echo 'Found external IP: '$ip
  say "service $1 has an external ip"
}

get_secret() {
  [[ $# -lt 1 ]] && {
		local _sec_and_ns=$(kubectl get secrets --no-headers -A | fzf --header "Select a secret" -e)
		local _ns=$(echo $_sec_and_ns | awk '{print $1}')
		local _sec=$(echo $_sec_and_ns | awk '{print $2}')
    _cmd_args="$_sec -n $_ns"
  } || _cmd_args=$@

  kubectl get secret -o go-template='{{range $k,$v := .data}}{{printf "%s:\n" $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}' $(echo ${_cmd_args})
}

kpl() {
  _cmd_args=$1
  [[ $# -lt 1 ]] && {
    local _pod_and_ns=$(kubectl get pods --no-headers -A | fzf --header "Select a pod" -e)
    local _ns=$(echo $_pod_and_ns | awk '{print $1}')
    local _pod=$(echo $_pod_and_ns | awk '{print $2}')
    local _cont_num=$(echo $_pod_and_ns | awk '{print $3}' | cut -d'/' -f2)
    _cmd_args="$_pod -n $_ns"
    # if there are more containers ask for a container name
    [[ $_cont_num -gt 1 ]] && {
      local _cont_name=$(kubectl get pod -n $_ns $_pod -o jsonpath='{.spec.containers[*].name}' | tr ' ' '\n' | fzf --header "the pod has 2 or more containers, select a container" -e)
      _cmd_args="$_cmd_args -c $_cont_name"
    }
  }
  echo "kubectl logs -f $_cmd_args | grep -i " | pbcopy
  echo "kubectl logs -f $_cmd_args"
  kubectl logs -f `echo $_cmd_args` || {
    out=$(kubectl logs -f `echo $_cmd_args` 2>&1 > /dev/null)
    if echo $out | grep -q "error: a container name must be specified for pod" ; then
      local _cont_name=$(echo $out | sed -e 's/.*choose one of: \[//g' -e 's/]//g' | tr ' ' '\n' | fzf -e)
      kubectl logs -f `echo $_cmd_args` -c $_cont_name
      echo "kubectl logs -f $_cmd_args -c $_cont_name"
      return
    fi
  }
  echo "kubectl logs -f $_cmd_args"
}

kp() {
  kubectl get pods $@ | awk '{print $1 " " $2 " " substr($4,1,7) " " $5}' | column -t | lolcat
}

kshell() {
  [[ $# -lt 1 ]] && echo "usage: kshell <pod_name>]" && return
  kubectl exec -ti $@ -- /bin/sh -c 'command -v bash &> /dev/null && bash || sh'
  #kubectl exec -ti $1 -- command -v bash &> /dev/null && kubectl exec -ti $1 -- bash || kubectl exec -ti $1 -- sh
}
#complete -o default -F __kubectl_get_resource_pod kshell
