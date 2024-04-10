#!/bin/bash

# command -v opsctl &> /dev/null && source <(opsctl completion zsh)

# opsctl 1> /dev/null || {
#   echo "Updating opsctl.."
#   opsctl version update
# }

function cordon() {
  # also there is flux suspend helmrelease ..
  [ "x$1" = "x-n" ] && {
    ns=$2
    arg=$3
  } || {
    ns=giantswarm
    arg=$1
  }
  kubectl -n $ns annotate app $arg 'app-operator.giantswarm.io/cordon-reason'='Maintenance in progress'
  kubectl -n $ns annotate app $arg 'app-operator.giantswarm.io/cordon-until'=$(date -v +1d '+%Y-%m-%dT%H:%M:%S')
  kubectl -n giantswarm annotate chart $arg 'chart-operator.giantswarm.io/cordon-reason'='Maintenance in progress'
  kubectl -n giantswarm annotate chart $arg 'chart-operator.giantswarm.io/cordon-until'=$(date -v +1d '+%Y-%m-%dT%H:%M:%S')
}

function uncordon() {
    [ "x$1" = "x-n" ] && {
    ns=$2
    arg=$3
  } || {
    ns=giantswarm
    arg=$1
  }
  kubectl -n giantswarm annotate chart $arg chart-operator.giantswarm.io/cordon-reason-
  kubectl -n giantswarm annotate chart $arg chart-operator.giantswarm.io/cordon-until-
  kubectl -n $ns annotate app $arg chart-operator.giantswarm.io/cordon-reason-
  kubectl -n $ns annotate app $arg chart-operator.giantswarm.io/cordon-until-
}

function openstack-clean-volumes() {
  openstack volume list | grep available | awk -F ' ' '{print "openstack volume delete" $2}'
}

function k() {
  local -a args=( kubectl )               # initialize argument list to "kubectl"
  for arg do                              # iterate over each funtion argument
    if [[ $arg = 2y ]]; then              # if that argument is "gpf"...
      args+=( "-oyaml" )
      "${args[@]}" | cat -l yaml
      return
    else
      args+=( "$arg" )                    # otherwise, just append what we were given
    fi
  done
  "${args[@]}"                           # then run our list as a command.
}

function h() {
  local -a args=( helm )
  for arg do                              # iterate over each funtion argument
    if [[ $arg = 2y ]]; then              # if that argument is "gpf"...
      "${args[@]}" | cat -l yaml
      return
    else
      args+=( "$arg" )                    # otherwise, just append what we were given
    fi
  done
  "${args[@]}"                           # then run our list as a command.
}

function k_set(){
  export KUBECONFIG=~/.kube/$1
}

function k_set_wc(){
  export KUBECONFIG=~/.kube/wc/$1
}

function k_get_wc(){
  local _ns=${2:-org-multi-project}
  clusterctl -n ${_ns} get kubeconfig $1 > ~/.kube/wc/$1
}

function k_print(){
  echo $KUBECONFIG
}

function k_reset(){
  unset KUBECONFIG
}

function k_remove(){
  rm $KUBECONFIG
  rm ~/.kube/config
}

# CAPV

alias capvlog='k logs -f -l cluster.x-k8s.io/provider=infrastructure-vsphere -n giantswarm --tail=-1 | sed -e "s;^E.*;$(tput setaf 1)&$(tput sgr0);g"'
alias capvlogErr='k logs -f -l cluster.x-k8s.io/provider=infrastructure-vsphere -n giantswarm --tail=-1 | grep "^E"'

govc_delete_vms(){
  local _vms=$(govc ls /Datacenter/vm/ | fzf -m --header "Select VM(s) to be deleted by Shift+Tab")
  echo "Are you sure to delete following vms:"
  echo "${_vms}" | awk '{print "- " $0}'
  echo "[y/N]?"
  read _resp
  [[ $_resp =~ [yY] ]] && govc vm.destroy $(echo ${_vms} | tr -d ' ')
}

copy_cfg() {
  IP=${1}
  ssh -o "StrictHostKeyChecking=no" -i ~/.ssh/giantswarm-sso-ed25519 root@${IP} -- mkdir -p /etc/containerd/conf.d/
  scp -o "StrictHostKeyChecking=no" -i ~/.ssh/giantswarm-sso-ed25519 ~/registry-config.toml root@${IP}:/etc/containerd/conf.d/registry-config.toml
  ssh -o "StrictHostKeyChecking=no" -i ~/.ssh/giantswarm-sso-ed25519 root@${IP} -- "systemctl restart containerd && systemctl status containerd"
}

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

get_wcs_kvm() {
  kubectl get kvmclusterconfigs -o yaml | yq '.items[].spec.guest.id'
}

get_machines_in_installation(){
  opsctl show installation -i ${1} | yq -r '.Machines'
}

lpass_edit(){
  _all=$(lpass ls --color=always)
  lpass edit --sync=now $(echo $_all | fzf --ansi | sed 's/^.*id: \([0-9]\+\).*$/\1/g')
}

source ~/.giantswarm-personal.sh
