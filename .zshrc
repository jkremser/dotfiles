export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# completions
for f in `find ~/.completion -type f`; do
  #source $f;
  zstyle ':completion:*:*:git:*' script $f
done

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(colorize docker helm minikube kubectl)

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
alias wp="watch kubectl get pods"

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

#java_version
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs ram kubecontext)

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)

ifconfig | grep 10\.173\. &> /dev/null && {
  export http_proxy="http://www-proxy.us.oracle.com:80"
  export HTTP_PROXY=$http_proxy
  export https_proxy=$http_proxy
  export HTTPS_PROXY=$https_proxy
  #,0,1,2,3,4,5,6,7,8,9
  export no_proxy="localhost,.oracle.com,.oraclecorp.com,192.168.64.1,192.168.64.2,192.168.64.3.192.168.64.4,192.168.64.5,192.168.64.6,192.168.64.7,192.168.64.8,192.168.64.9,10.96.0.1"
  export NO_PROXY=$no_proxy
  git config --global http.proxy $HTTP_PROXY
} || {
  git config --global --unset http.proxy
  git config --global --unset https.proxy
  export http_proxy=
  export HTTP_PROXY=
  export https_proxy=
  export HTTPS_PROXY=
}
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"


#work
alias graalOp="cd $WORKSPACE/graal-cloud/operators/graal-operator/ && sayCWD graal-op"
alias sop='cd $WORKSPACE/jvm-operators/spark-operator && sayCWD spark-op'
alias sap='cd $WORKSPACE/jvm-operators/abstract-operator && sayCWD abstract-op'


# kubectl tonative plugin
export PATH="/Users/jkremser/bin:/usr/local/bin:/Users/jkremser/install/graalvm-ce-19.2.1/Contents/Home/bin/:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:/Users/jkremser/workspace/graal-cloud/operators/graal-operator/kubectl-plugin:/Users/jkremser/workspace/graal-cloud/operators/graal-operator/kubectl-plugin"
