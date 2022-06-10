autoload -Uz compinit
compinit

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ "x$ZSH_DEBUG" == "x" ]] || zmodload zsh/zprof

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

#source ~/powerlevel10k/powerlevel10k.zsh-theme
export PATH=$HOME/bin:/usr/local/bin:$PATH
export EDITOR=vim
#export FILTER_BRANCH_SQUELCH_WARNING=1

# Path to your oh-my-zsh installation.
#export ZSH="$HOME/.oh-my-zsh"
#source $ZSH/oh-my-zsh.sh

# completions
#for f in `find ~/.completion -type f`; do
#  #source $f;
#  #zstyle ':completion:*:*:git:*' script $f
#done

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(colorize docker helm minikube kubectl)
if [[ "$OSTYPE" == "darwin"* ]]; then
  plugins=(osx)
  # switch ~ and ±
  hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x700000064},{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035}]}' &> /dev/null
  bindkey "^[[F" end-of-line
  bindkey "^[[H" beginning-of-line
  bindkey "§" '`'
  bindkey "±" '~'
  # this requires to set the escape code that's send when pressing option + right to ff (workaround to mac bullshit)
  bindkey "^[ff" forward-word

  # env
  export HOMEBREW_NO_AUTO_UPDATE=1

  source ~/.mac.sh
else
  true # currently noop
fi


POWERLEVEL9K_MODE='nerdfont-complete'
ZSH_THEME="powerlevel10k/powerlevel10k"


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

#When share_history is enabled, it reads and writes to the history file.
setopt share_history

#When inc_append_history is enabled, it only writes to the history file.
unsetopt inc_append_history
export HISTFILESIZE="10000000"
export HISTSIZE="10000000"
export SAVEHIST="${HISTSIZE}00"
export HISTFILE=~/.zsh_history
setopt append_history

#setopt incappendhistory
#bindkey "^[[A" ihistory-search-backward
#bindkey "^[[B" history-search-forward
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

alias g="git "

# <git>
alias g="git "
alias ga="git add -A"
alias gl="git l"
alias gls="git ls"
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

export LSCOLORS="ExfxcxdxCxegecabagacad"
alias ls="ls -GH"
alias ll="ls -l"

gShowPr() {
  [[ "x$1" == "x" ]] || git fetch origin pull/$1/head:pr$1 && g cd pr$1
}

prs() {
  _PR_NUM=$(gh pr list | cut -f -2 | fzf --header "Select PR to checkout" --ansi --cycle --preview-window bottom:70% --preview "gh pr diff --color=always {1}" | cut -f1)
   git fetch origin pull/${_PR_NUM}/head:pr${_PR_NUM} && git checkout pr${_PR_NUM}
}

cleanBranches() {
  _TO_DELETE=$(g ls | grep -v " master$" | fzf -m --tac --no-sort --header "Use Shift+Tab to select multiple branches to delete" | cut -d' ' -f2)
  [[ "x$_TO_DELETE" == "x" ]] || {
    echo -e "selected branches:\n$(echo $_TO_DELETE | sed 's/^\s\?/- /g')\n"
    read "ans?Are you sure you want to delete them? $TEXT_RED<y/n>$RESET_FORMATTING "
    [[ $ans == "y" ]] && for b in `echo $_TO_DELETE`; do git branch -D $b; done;
  }
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
  G_REMOTE=`git remote -v | head -1 | sed 's;.*://github.com/[^/]*\([^\ ]*\).*;git@github.com:jkremser\1;g'` || true
  g remote add personal $G_REMOTE
}
alias gper="personalize"
#</git>

# safe rm
#alias rm='rm --preserve-root'

#https://github.com/jingweno/ccat/releases
#alias cat="ccat --bg=dark "
#https://github.com/sharkdp/bat
alias cat="bat "
alias catt="bat --plain "
export BAT_THEME="Visual Studio Dark+"

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
alias woc='wp'
#alias kp='kubectl get pods | awk {'"'"'print $1" " $2" " substr($4,1,3)" " $5'"'"'} | column -t'
alias kpp='kubectl get pods -A'
alias kpa="kp -A"
alias kpd="kubectl delete pod --wait=false"
#alias kpl="kubectl logs -f"
alias ns="kubectl config set-context --current --namespace=\$(kubectl get ns --no-headers | fzf -e | cut -d' ' -f1)"

#xxd or cat captures the code
bindkey -s '^[[1;2P' 'k9s\n'
bindkey -s '^[[1;2S' 'kp\n'
bindkey -s '^[[15;2~' 'kshell\t\t\t\t'
#bindkey -s '^[[15;2~' ''
#bindkey -s '^[[17;2~' ''
bindkey -s '^[[18;2~' '~/helper.sh\n'

# for setting up option and backspace and arrows see:
#https://medium.com/@jonnyhaynes/jump-forwards-backwards-and-delete-a-word-in-iterm2-on-mac-os-43821511f0a

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
  echo "kubectl logs -f $_cmd_args"
  kubectl logs -f `echo $_cmd_args` || {
    out=$(kubectl logs -f `echo $_cmd_args` 2>&1 > /dev/null)
    if echo $out | grep -q "error: a container name must be specified for pod" ; then
      local _cont_name=$(echo $out | sed -e 's/.*choose one of: \[//g' -e 's/]//g' | tr ' ' '\n' | fzf -e)
      kubectl logs -f `echo $_cmd_args` -c $_cont_name
    fi
  }
}

kp() {
  kubectl get pods $@ | awk '{print $1 " " $2 " " substr($4,1,7) " " $5}' | column -t | lolcat
}

kshell() {
  [[ $# -lt 1 ]] && echo "usage: kshell <pod_name>]" && return
  kubectl exec -ti $@ -- /bin/sh -c 'command -v bash &> /dev/null && bash || sh'
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

#vcs
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)

export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$HOME/.cargo/bin"

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
alias graalOp="cd $WORKSPACE/graal-cloud/graal-operator && sayCWD graal-op"
alias sop='cd $WORKSPACE/jvm-operators/spark-operator && sayCWD spark-op'
alias sap='cd $WORKSPACE/jvm-operators/abstract-operator && sayCWD abstract-op'
alias kgb='cd $WORKSPACE/k8gb && sayCWD k8gb'


source ~/.personal.sh
source ~/.functions
source ~/.fzf-bindings.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/jkremser/.sdkman"
[[ -s "/Users/jkremser/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/jkremser/.sdkman/bin/sdkman-init.sh"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="${PATH}:${HOME}/.krew/bin"


#autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# this should be in the end
[[ "x$ZSH_DEBUG" == "x" ]] || zprof && export ZSH_DEBUG=""

export AWS_PROFILE=saml
export GOPATH="${HOME}/.go"
#export GOROOT="/usr/local/go/"
#export GOROOT="/usr/local/opt/go@1.17"
#export GOROOT=/usr/local/opt/go/libexec
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
test -d "${GOPATH}" || mkdir "${GOPATH}"
test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"

source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='λ'


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#kubectl log2rbac __complete "\$@"
export PATH="/usr/local/opt/go@1.17/bin:$PATH"

export GO111MODULE=on
export GOPROXY=https://goproxy.cn
