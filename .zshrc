export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# completions
for f in `find ~/.completion -type f`; do
  #source $f;
  #zstyle ':completion:*:*:git:*' script $f
done

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(colorize docker helm minikube kubectl)
if [[ "$OSTYPE" == "darwin"* ]]; then
  plugins=(osx)
else
  true # currently noop
fi


POWERLEVEL9K_MODE='nerdfont-complete'
ZSH_THEME="powerlevel9k/powerlevel9k"



source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8


# Formatting constants
export BOLD=$(tput bold)
export UNDERLINE_ON=$(tput smul)
export UNDERLINE_OFF=$(tput rmul)
export TEXT_BLACK=$(tput setaf 0)
export TEXT_RED=$(tput setaf 1)
export TEXT_GREEN=$(tput setaf 2)
export TEXT_YELLOW=$(tput setaf 3)
export TEXT_BLUE=$(tput setaf 4)
export TEXT_HAWKULARBLUE=$(tput setaf 39)
export TEXT_MAGENTA=$(tput setaf 5)
export TEXT_CYAN=$(tput setaf 6)
export TEXT_WHITE=$(tput setaf 7)
export TEXT_ORANGE=$(tput setaf 172)
export BACKGROUND_BLACK=$(tput setab 0)
export BACKGROUND_RED=$(tput setab 1)
export BACKGROUND_GREEN=$(tput setab 2)
export BACKGROUND_YELLOW=$(tput setab 3)
export BACKGROUND_BLUE=$(tput setab 4)
export BACKGROUND_MAGENTA=$(tput setab 5)
export BACKGROUND_CYAN=$(tput setab 6)
export BACKGROUND_WHITE=$(tput setab 7)
export RESET_FORMATTING=$(tput sgr0)

# history
export HISTFILESIZE="10000000"
export HISTSIZE="10000000"

alias g="git"

# <git>
alias g="git "
alias ga="git add -A"
alias gl="git l"
alias gl1="git l1"
alias gg="git g"
alias gst="git st"
alias gs="gst" # sorry, ghost script
alias gpl="git pl"
alias gpll="git pll"
alias gppm="git push personal master"
alias gd="git dif"
alias gdf="gd"
alias gap="git ap"
alias grc="git rc"
alias gra="git ra"

gShowPr() {
  [[ "x$1" == "x" ]] || git fetch origin pull/$1/head:pr$1 && g cd pr$1
}

gBak() {
  local _current_branch=$(git rev-parse --abbrev-ref HEAD  2> /dev/null)
  local _suffix="_bak"
  local _candidate="$_current_branch""$_suffix"
  while git rev-parse --verify $_candidate &> /dev/null && true ; do
    _candidate="$_candidate""$_suffix"
  done
  git checkout -b $_candidate
  echo "branch $_candidate created"
  git checkout -
}

personalize() {
  G_REMOTE=`git remote -v | head -1 | sed 's;.*\(https://github.com/\)[^/]*\([^\ ]*\).*;git@github.com:jkremser\2;g'` || true
  #sed -i'' 's;remote "origin";remote "personal";g' .git/config || true
  #sed -i'' 's;https\?://github.com/jkremser;git@github.com:jkremser;g' .git/config || true
  g remote add personal $G_REMOTE
}
alias gper="personalize"
#</git>

# safe rm
#alias rm='rm --preserve-root'

alias cat="ccat --bg=dark "

# Start a web service on port 8000 that uses CWD as its document root.
if type ruby &> /dev/null; then
  alias share="ruby -run -e httpd . -p 8000"
else
  alias share="python -m SimpleHTTPServer"
fi

#sudo
alias s=sudo
alias plz=sudo

export WORKSPACE="$HOME/workspace"

sayCWD() {
  [[ "x$1" == "x" ]] || echo ${TEXT_HAWKULARBLUE} && figlet -f ~/ogre.flf -m8 $1 && echo ${RESET_FORMATTING} && echo "Current directory is:" && pwd
}

#docker
alias d="docker"
alias dc="docker-compose"

#kubectl
command -v kubectl &> /dev/null && source <(kubectl completion zsh)
alias k="kubectl"
alias kc="kubectl"
alias wp='watch kubectl get pods'
alias kp='kubectl get pods | awk {'"'"'print $1" " $2" " substr($4,1,3)" " $5'"'"'} | column -t'
alias kpd="kubectl delete pod --wait=false"
alias kpl="kubectl logs -f"

#xxd or cat captures the code
bindkey -s '^[[1;2P' 'k9s\n'
bindkey -s '^[[1;2S' 'kp\n'
bindkey -s '^[[15;2~' 'kshell\t\t\t'
#bindkey -s '^[[15;2~' ''
#bindkey -s '^[[17;2~' ''
#bindkey -s '^[[18;2~' ''

kshell() {
  [[ $# -lt 1 ]] && echo "usage: kshell <pod_name>]" && return
  kubectl exec -ti $1 -- /bin/sh -c 'command -v bash &> /dev/null && bash || sh'
  #kubectl exec -ti $1 -- command -v bash &> /dev/null && kubectl exec -ti $1 -- bash || kubectl exec -ti $1 -- sh
}
complete -o default -F __kubectl_get_resource_pod kshell

# -------------------------------- POWERLEVEL ---------------------------------


POWERLEVEL9K_RAM_BACKGROUND="darkred"
POWERLEVEL9K_RAM_FOREGROUND="249"
POWERLEVEL9K_RAM_ELEMENTS=(ram_free)
POWERLEVEL9K_KUBECONTEXT_BACKGROUND="navyblue"
POWERLEVEL9K_KUBECONTEXT_FOREGROUND="249"
P9KGT_TERMINAL_BACKGROUND=231
DIR_BACKGROUND=241
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="darkgreen"
# Set 'dir' segment colors
# https://github.com/bhilburn/powerlevel9k/blob/next/segments/dir/README.md
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND=$P9KGT_TERMINAL_BACKGROUND
POWERLEVEL9K_DIR_HOME_FOREGROUND=$P9KGT_TERMINAL_BACKGROUND
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=$P9KGT_TERMINAL_BACKGROUND
POWERLEVEL9K_DIR_ETC_FOREGROUND=$P9KGT_TERMINAL_BACKGROUND
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND=$DIR_BACKGROUND
POWERLEVEL9K_DIR_HOME_BACKGROUND=$DIR_BACKGROUND
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND=$DIR_BACKGROUND
POWERLEVEL9K_DIR_ETC_BACKGROUND=$DIR_BACKGROUND
#POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
#POWERLEVEL9K_SHORTEN_STRATEGY=truncate_with_folder_marker
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_from_right
#POWERLEVEL9K_SHORTEN_DELIMITER=*
#POWERLEVEL9K_SHORTEN_STRATEGY=truncate_folders
POWERLEVEL9K_USE_CACHE=true
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='black'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='green'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='black'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='green'

#java_version  #kubecontext
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs ram)

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)

ifconfig | grep 10\.173\. &> /dev/null && {
  export http_proxy="http://www-proxy.us.oracle.com:80"
  export HTTP_PROXY=$http_proxy
  export https_proxy=$http_proxy
  export HTTPS_PROXY=$https_proxy
  #,0,1,2,3,4,5,6,7,8,9
  no_proxy="localhost,.oracle.com,.oraclecorp.com"
  for i in {1..50}; do no_proxy="$no_proxy,192.168.64.$i" ; done
  for i in {1..25}; do no_proxy="$no_proxy,172.17.0.$i" ; done
  for i in {1..35}; do no_proxy="$no_proxy,10.173.205.$i" ; done
  no_proxy="$no_proxy"
  export no_proxy
  export NO_PROXY=$no_proxy
  git config --global http.proxy $HTTP_PROXY
  cp ~/.m2/settings.xml ~/.m2/settings.xml-bak
  cp ~/.m2/settings.xml-oracle ~/.m2/settings.xml
} || {
  git config --global --unset http.proxy
  git config --global --unset https.proxy
  export http_proxy=
  export HTTP_PROXY=
  export https_proxy=
  export HTTPS_PROXY=
  cp ~/.m2/settings.xml ~/.m2/settings.xml-bak
  cp ~/.m2/settings.xml-normal ~/.m2/settings.xml
}
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

#work
alias graalOp="cd $WORKSPACE/graal-operator/ && sayCWD graal-op"
alias sop='cd $WORKSPACE/jvm-operators/spark-operator && sayCWD spark-op'
alias sap='cd $WORKSPACE/jvm-operators/abstract-operator && sayCWD abstract-op'


source ~/.personal.sh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/jkremser/.sdkman"
[[ -s "/Users/jkremser/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/jkremser/.sdkman/bin/sdkman-init.sh"


# kubectl tonative plugin
export PATH="/Users/jkremser/bin:/Users/jkremser/.sdkman/candidates/sbt/current/bin:/Users/jkremser/.sdkman/candidates/micronaut/current/bin:/Users/jkremser/.sdkman/candidates/java/current/bin:/Users/jkremser/bin:/usr/local/bin:/Users/jkremser/install/graalvm-ce-19.2.1/Contents/Home/bin/:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:/Users/jkremser/workspace/graal-cloud/operators/graal-operator/kubectl-plugin:/Users/jkremser/workspace/graal-cloud/operators/graal-operator/kubectl-plugin:/Users/jkremser/workspace/graal-operator/kubectl-plugin"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform