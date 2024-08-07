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

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  plugins=(osx git opsctl kubectl)
  # switch ~ and ±
  hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x700000064},{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035}]}' &> /dev/null
  bindkey "^[[F" end-of-line
  bindkey "^[[H" beginning-of-line
  bindkey "§" '`'
  bindkey "±" '~'
  # this requires to set the escape code that's send when pressing option + right to ff (workaround to mac bullshit)
  bindkey "^[ff" forward-word
  #xxd or cat captures the code
  bindkey -s '^[[1;2P' 'k9s\n'
  bindkey -s '^[[1;2S' 'kp\n'
  bindkey -s '^[[15;2~' 'kshell\t\t\t\t'
  #bindkey -s '^[[15;2~' ''
  #bindkey -s '^[[17;2~' ''
  bindkey -s '^[[18;2~' '~/helper.sh\n'
  bindkey -s '^[[17;2~' '¯\\_(ツ)_/¯'

  # env
  export HOMEBREW_NO_AUTO_UPDATE=1

  source ~/.mac.sh
else
  true # currently noop
fi




export LANG=en_US.UTF-8

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


# <git>
alias g="git "
alias ga="git add -A"
alias gl="git l"
alias gls="git ls"
alias gl1="git l1"
alias gg="git g"
alias gst="git st"
alias gs="gst" # sorry, ghost script
# alias gpl="git pl"
alias gpll="git pll"
alias gd="git dif"
alias gdf="gd"
alias gap="git ap"
alias grc="git rc"
alias gra="git ra"
# </git>

export LSCOLORS="ExfxcxdxCxegecabagacad"
alias ls="ls -GH"
alias ll="ls -l"

alias grep="grep --color"

#https://github.com/jingweno/ccat/releases
#alias cat="ccat --bg=dark "
#https://github.com/sharkdp/bat
alias cat="bat "
alias catt="bat --plain --style=plain --paging=never "
alias ccat="catt"
alias catl="cat -l yaml"
export BAT_THEME="Visual Studio Dark+"

# Start a web service on port 8000 that uses CWD as its document root.
if type ruby &> /dev/null; then
  alias share="ruby -run -e httpd . -p 8000"
else
  alias share="python -m SimpleHTTPServer"
fi

alias s=sudo

export WORKSPACE="$HOME/workspace"

#docker
alias d="docker"
alias dc="docker-compose"

#kubectl
command -v kubectl &> /dev/null && source <(kubectl completion zsh)

#helm
command -v helm &> /dev/null && source <(helm completion zsh)

#cosign
command -v cosign &> /dev/null && source <(cosign completion zsh)
command -v syft &> /dev/null && source <(syft completion zsh)


# kubecolor
export KUBECOLOR_OBJ_FRESH="2m"
export KUBECOLOR_THEME_DATA_STRING="white"
compdef kubecolor=kubectl

#alias k="kubectl"
#alias compdef k="kubectl"
alias compdef k="kubecolor"
alias kc="kubectl"
alias wp='watch kubectl get pods'
alias woc='wp'
alias watch='watch -t --color '
#alias kp='kubectl get pods | awk {'"'"'print $1" " $2" " substr($4,1,3)" " $5'"'"'} | column -t'
alias kpp='k get pods -A --force-colors'
alias kpa="kp -A"
alias kpd="k delete pod --wait=false"
#alias kpl="kubectl logs -f"
alias ns="kubectl config set-context --current --namespace=\$(kubectl get ns --no-headers | fzf -e | cut -d' ' -f1)"



# for setting up option and backspace and arrows see:
# iTerm preferences select Profiles > Keys > Key Mappings > Presets > Nature Text Editing



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

# source personal
for f in ~/.personal.sh \
         ~/.giantswarm-personal.sh \
         ~/.giantswarm-openrc.sh
do
  [[ -f $f ]] && source $f
done

# source functions
for f in $(ls -A ~/.functions); do
  source ~/.functions/$f
done

export SDKMAN_DIR="/Users/jkremser/.sdkman"
[[ -s "/Users/jkremser/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/jkremser/.sdkman/bin/sdkman-init.sh"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="${PATH}:${HOME}/.krew/bin"
export PATH="${PATH}:${HOME}/install/govc_Darwin_arm64"


zstyle ':completion:*:*:make:*' tag-order 'targets'
autoload -U +X bashcompinit && bashcompinit

#complete -o nospace -C /usr/local/bin/terraform terraform

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



export AWS_PROFILE=saml
export GOPATH="${HOME}/.go"
export GOBIN="${GOPATH}/bin" && mkdir $GOBIN &> /dev/null
#export GOROOT="/usr/local/go/"
#export GOROOT="/usr/local/opt/go@1.17"
#export GOROOT=/usr/local/opt/go/libexec
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
test -d "${GOPATH}" || mkdir "${GOPATH}"
test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"

source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='λ'


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#kubectl log2rbac __complete "\$@"
export PATH="/opt/homebrew/opt/go/bin:$PATH"
export PATH="$GOBIN:$PATH"

export GO111MODULE=on
#export GOPROXY=https://goproxy.cn
PATH="/Users/jkremser/Library/Python/3.8/bin:$PATH"
PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jkremser/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jkremser/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jkremser/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jkremser/Downloads/google-cloud-sdk/completion.zsh.inc'; fi


# this should be in the end
[[ "x$ZSH_DEBUG" == "x" ]] || zprof && export ZSH_DEBUG=""
export PATH="/usr/local/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
