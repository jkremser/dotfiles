# .bashrc (Jiri Kremser)

# Source global definitions
[ -f /etc/bashrc ] && source /etc/bashrc

# completions
for f in `find ~/.completion -type f`; do source $f; done

# bash completion working with the 'g' alias
complete -o default -o nospace -F _git g

getSpecialChar() {
  #_SPECIAL="👒"
  _SPECIAL_GULP="🍄"
  _SPECIAL_MVN="🏃"
  #_SPECIAL="👣"
  #_SPECIAL="💊"
  #_SPECIAL="💩"
  _SPECIAL_NORMAL="💲"
  _SPECIAL_DOCKER_COMPOSE="🔨"
  _SPECIAL_CODE="λ"

  [[ `git rev-parse --is-inside-work-tree 2> /dev/null` ]] && {
    d=`pwd`
    [[ -s "$d/pom.xml" ]] && {
      echo $_SPECIAL_MVN
      exit
    }
    [[ -s "$d/gulpfile.js" ]] && {
      echo $_SPECIAL_GULP
      exit
    }
    [[ -s "$d/docker-compose.yaml" ]] || [[ -s "$d/docker-compose.yml" ]] && {
      echo $_SPECIAL_DOCKER_COMPOSE
      exit
    }

    echo $_SPECIAL_CODE
    exit
  }
  echo $_SPECIAL_NORMAL
}

#git cmd line branch highlighting
promptText() {    
  #CODE=$?;
  CODE=$1;
  CODE_STR="";
  GITBRANCH=$(git rev-parse --abbrev-ref HEAD  2> /dev/null);
  YELLOW="\[\033[0;33m\]";
  BLUE="\[\033[0;34m\]";
  LIGHT_BLUE="\[\033[0;36m\]";
  RED="\[\033[0;31m\]";
  LIGHT_RED="\[\033[1;31m\]";
  GREEN="\[\033[0;32m\]";
  LIGHT_GREEN="\[\033[1;32m\]";
  WHITE="\[\033[1;37m\]";
  LIGHT_GRAY="\[\033[0;37m\]";
  NORMAL="\[\033[0m\]";
  [ $CODE != 0 ] && CODE_STR="($CODE)";
  _SPECIAL=`getSpecialChar`
  PS1="[\u@\h \W$GREEN $GITBRANCH$NORMAL]";
  PS1="\[\033[G\]$PS1$RED$CODE_STR$NORMAL$_SPECIAL ";
}
#export PROMPT_COMMAND=promptText

#PS1='[\u@\h \W\[\033[0;32m\]$(__git_ps1 " %s")\[\033[00m\]]\$ '
#PS1="\[\033[G\]$PS1"

pick(){
  echo $@ | tr ',' '\n' | tr ' ' '\n' | sort -R | head -1
}

function which(){
  readlink -f $( which $1 )
}

bcp(){
  cp $1{,-$( date +%F )}
}

log(){
  less +F $1 |egrep --line-buffered --color=auto 'ERROR|WARN|$' # tail log & highlight errors (if your grep supports --color)
}

certAdd(){
  certutil -d sql:$HOME/.pki/nssdb -A -t "P,," -n $1 -i $1
}

##### </Maven colors>
# Mvn color (https://gist.github.com/1027800) 
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
 
# Wrapper function for Maven's mvn command.
mvnColor() {
  mvn $@ | sed -e "s/\(\[INFO\]\ \[.*\)/${RESET_FORMATTING}\1${RESET_FORMATTING}/g" \
               -e "/\[INFO\]\ Building\ \(war\:\|jar\:\|ear\:\)/! s/\(\[INFO\]\ Building .*\)/${TEXT_BLUE}\1${RESET_FORMATTING}/g" \
               -e "s/\(\[INFO\]\ BUILD SUCCESSFUL\)/${TEXT_GREEN}\1${RESET_FORMATTING}/g" \
               -e "s/\(\[INFO\]\ BUILD FAILURE\)/${TEXT_RED}\1${RESET_FORMATTING}/g" \
               -e "s/\(\[WARNING\].*\)/${TEXT_YELLOW}\1${RESET_FORMATTING}/g" \
               -e "s/\(\[ERROR\].*\)/${TEXT_RED}\1${RESET_FORMATTING}/g" \
               -e "s/\(Caused by: .*\)/${BOLD}${TEXT_ORANGE}\1${RESET_FORMATTING}/g" \
               -e "s/\(org\.rhq\..*\)/${BOLD}\1${RESET_FORMATTING}/g" \
               -e "s/\(org\.hawkular\..*\)/${BOLD}\1${RESET_FORMATTING}/g" \
               -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/${BOLD}${TEXT_GREEN}Tests run: \1${RESET_FORMATTING}, Failures: ${BOLD}${TEXT_RED}\2${RESET_FORMATTING}, Errors: ${BOLD}${TEXT_RED}\3${RESET_FORMATTING}, Skipped: ${BOLD}${TEXT_YELLOW}\4${RESET_FORMATTING}/g"
  echo -ne ${RESET_FORMATTING}
}
alias m="mvnColor"
##### </Maven colors>

logColor() {
  echo $@
  [ $# = 0 ] && exit
  $@ | sed -e "s/\(\ INFO\ \ .*\)/${RESET_FORMATTING}\1${RESET_FORMATTING}/g" \
           -e "s/\(\ WARN\ \ .*\)/${TEXT_YELLOW}\1${RESET_FORMATTING}/g" \
           -e "s/\(\ ERROR\ .*\)/${TEXT_RED}\1${RESET_FORMATTING}/g" \
           -e "s/\(org\.rhq\..*\)/${BOLD}\1${RESET_FORMATTING}/g" \
           -e "s/\(org\.hawkular\..*\)/${BOLD}\1${RESET_FORMATTING}/g" \
           -e "s/\(Caused by: .*\)/${BOLD}${TEXT_RED}\1${RESET_FORMATTING}/g"
}

# Make box around text.
box() { t="$1xxxx";c=${2:-=}; echo ${t//?/$c}; echo "$c $1 $c"; echo ${t//?/$c}; }

# make nice commit log output for BugZilla
gll() {
  BRANCH=`git rev-parse --abbrev-ref HEAD 2> /dev/null | tr '/' '?'`
  git l4-helper | sed -e "s/%REPLACE%/${BRANCH}/" -e "s/\?/\\//"
}

# simple webcam timelapse toolkit
timelapse() {
  i=0
  while true; do
  figlet "Frame: $i"
  mplayer tv:// -vo jpeg -frames 1 > /dev/null 2>&1
  mv 00000001.jpg img_$(date +%s).jpg
  sleep 1
  ((i++))
  done;
}
alias timelapsePreview="mplayer mf://*.jpg"
alias timelapseEncode="mencoder mf://*.jpg -ovc lavc -o out.avi"

#make ~? typo work as ~/
: << 'END'
function cd {
  local target="$1"
  [[ $target == ~?* ]] && target="~/${target:2}"
  eval "builtin cd ${target}"
  return $?
}
END

#function vim {
#  local target="$1"
#  [[ $target == ~?* ]] && target="~/${target:2}"
#  eval "/usr/bin/vim ${target}"
#  return $?
#}

#melodyping(){ ping $1|awk -F[=\ ] '/me=/{t=$(NF-1);f=3000-14*log(t^20);c="play -q -n synth 0.7s pl " f;print $0;system(c)}';}

#aliases
alias mountPhone="simple-mtpfs --device 1 ~/foo"

# View HTTP traffic
alias sniff="sudo ngrep -d 'em1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i em1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# <git>
alias g="git "
alias gl="g l"
alias gl1="g l1"
alias gg="git g"
alias gst="g st"
alias gpl="g pl"
alias gpll="g pll"
alias gd="g dif"
alias gdf="gd"
alias gap="g ap"
alias grc="g rc"
alias gra="g ra"

gpr() {
  [[ "x$1" == "x" ]] || git fetch origin pull/$1/head:pr$1 && g cd pr$1
}

ggrp() {
  [[ $# -lt 2 ]] && echo "usage: ggrp <path_prefix_to_ignore> <search_pattern> [<grep_params>]" && return
  to_ignore=$1
  shift
  to_grep=$1
  shift
  params=$*
  git grep $params "$to_grep" -- `git ls-files | grep -v $to_ignore`
}

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
  G_REMOTE=`git remote -v | head -1 | sed 's;.*\(https://github.com/\)[^/]*\([^\ ]*\).*;git@github.com:Jiri-Kremser\2;g'`
  g remote add personal $G_REMOTE
}

alias gper="personalize"
#</git>

# general
alias psg='ps aux | grep'

alias untar="tar -xf"
alias untargz="tar -xfz"

# cd
alias ..='cd ..'
alias ...='cd ../../../'

# https://github.com/vigneshwaranr/bd
alias bd=". bd -s"

# safe rm
alias rm='rm --preserve-root'

# netstat
alias ports='netstat -tulanp'

# ignore some patterns during bash completion
export FIGNORE=.bat:.svn
bind 'set match-hidden-files off'

alias dlna="/home/jkremser/install/pms-1.72.0/PMS.sh"

# Start a web service on port 8000 that uses CWD as its document root.
if type ruby &> /dev/null; then
  alias share="ruby -run -e httpd . -p 8000"
else
  alias share="python -m SimpleHTTPServer"
fi

#Show a count of how many normal files are in the current directory and below.
alias fileNumber="find . -type f | wc -l"

#sudo
alias s=sudo
alias plz=sudo

#yum
alias di="sudo dnf install"
alias ds="sudo dnf search"

alias syslogs='s tail -f -n5 $(find /var/log -name \*log)'

#top on steroids
alias top="htop"

#grep on steroids
alias grp="ag"

# better formatting for mount
alias mountt='mount | column -t'

# Complement to whoami command.
alias whereami='echo "$( hostname --fqdn ) ($(hostname -i)):$( pwd )"'
#alias neco="melodyping"

alias rtfm="echo '16i[q]sa[ln0=aln100%Pln100/snlbx]sbA0D4D465452snlbxq' | dc"

#play short sounds
alias soundCow="paplay /usr/lib64/libreoffice/share/gallery/sounds/cow.wav"
alias soundHorse="paplay /usr/lib64/libreoffice/share/gallery/sounds/horse.wav"
alias soundTrain="paplay /usr/lib64/libreoffice/share/gallery/sounds/train.wav"

#train
alias train="(soundTrain&/home/jkremser/install/sl/sl)"

#vpn
alias vpnVsup='sudo /etc/init.d/openvpn stop && sleep 1 && sudo cp /etc/openvpn/client.conf_vsup /etc/openvpn/client.conf && sudo /etc/init.d/openvpn start'
alias vpnMzk='sudo /etc/init.d/openvpn stop && sleep 1 && sudo cp /etc/openvpn/client.conf_mzk /etc/openvpn/client.conf && sudo /etc/init.d/openvpn start'

#cert
alias certList="certutil -d sql:$HOME/.pki/nssdb -L" # add '-h all' to see all built-in certs"

# Quick search in a directory for a string
alias search="ack -i "

#rhq
export WORKSPACE="$HOME/workspace"
export RHQ_HOME="$WORKSPACE/rhq"
alias rhq='cd $WORKSPACE/rhq && echo ${TEXT_CYAN} && figlet RHQ && echo ${RESET_FORMATTING} && echo "Current directory is:" && pwd'
alias rhqGui='cd $WORKSPACE/rhq/modules/enterprise/gui/coregui && echo ${TEXT_MAGENTA} && figlet coregui && echo ${RESET_FORMATTING} && echo "Current directory is:" && pwd'
alias rtl="rhqctl"
complete -o default -o nospace -F _rhqctl rtl

sayCWD() {
  [[ "x$1" == "x" ]] || echo ${TEXT_HAWKULARBLUE} && figlet -f ~/ogre.flf -m8 $1 && echo ${RESET_FORMATTING} && echo "Current directory is:" && pwd
}

#daikon
alias daikon='cd $WORKSPACE/radanalyticsio && sayCWD radanalytics'
alias radanalytics='daikon'

#hawkular
alias hawk='cd $WORKSPACE/hawkular && sawCWD hawkular'
alias buildHawkular='m -U clean install -DskipTests -Pdev && ./dist/target/hawkular-1.0.0-SNAPSHOT/wildfly-8.2.0.Final/bin/standalone.sh --debug'
alias hawkR='cd $WORKSPACE/hawkular-client-ruby && sayCWD hawkular ruby client'
alias hawkS='cd $WORKSPACE/hawkular/hawkular-services && sawCWD hawkular services'
alias hawkRubyGem='cd $WORKSPACE/hawkular-client-ruby && sayCWD hawkular ruby gem'

#MiQ
alias miq='cd $WORKSPACE/manageiq && sayCWD MiQ'
alias miqUi='cd $WORKSPACE/manageiq/plugins/manageiq-ui-classic && sayCWD MIQ UI'

#other
alias hawkin='cd $WORKSPACE/hawkular/hawkinit && sayCWD hawkinit'
alias hawkfly='cd $WORKSPACE/hawkfly-domain-dockerfiles && sayCWD docker stuff'

alias runHawkS="hawkS && cd dist && m clean install -DskipTests -Pdev && ./target/hawkular-*/bin/standalone.sh -Dhawkular.log.cassandra=WARN -Dhawkular.log.inventory.rest.requests=DEBUG -Dhawkular.rest.user=jdoe -Dhawkular.rest.password=password -Dhawkular.agent.enabled=true"
alias runHawkSA="runHawkS -Dhawkular.agent.enabled=false"
alias buildRest="hawk && cd hawkular/modules/hawkular-api-parent && m clean install -Pdev -DskipTests"
alias runHawkAgentless="runHawk -Dhawkular.agent.enabled=false"
alias runHawkBusless="runHawkAgentless -Dinventory.bus.integration=false"
alias buildInv="hawk && cd hawkular-inventory && m clean install -DskipTests"
alias runCli="$RHQ_HOME/modules/enterprise/remoting/cli/target/rhq-remoting-cli-$RHQ_VERSION-SNAPSHOT/bin/rhq-cli.sh"
alias runCliLogin="runCli --user rhqadmin --password  rhqadmin"
alias ctailf="logColor tailf"
alias agentLog="logColor tail -f $RHQ_AGENT_INSTALL_DIR/logs/agent.log"
alias serverLog="logColor tail -f $RHQ_HOME/dev-container/rhq-server/logs/server.log"
alias pj='ps ax | grep java'
alias psj='pj'
alias killCassandra='kill -9 $(ps ax | grep cassandra | grep java | awk '\''{print $1}'\'')'
alias killAgent='kill -9 $(ps ax | grep AgentMain | grep java | awk '\''{print $1}'\'')'
alias killServer='kill -9 $(ps ax | grep rhq-server.properties | grep java | awk '\''{print $1}'\'')'
alias killRhq='killAgent; killCassandra; killServer'
alias killHawk='kill -9 $(ps ax | grep "standalone/log/server.log" | grep java | awk '\''{print $1}'\'')'
alias runMiq='bundle exec rake evm:start && bundle exec rails s'

alias webcam="ssh evanii@192.168.1.100 -Y 'mplayer tv://device=/dev/video0'"
alias microphone="arecord -f dat | ssh -C evanii@192.169.1.111 aplay -f dat"

alias hist="history -r; history"

#env
#history on steroids
export HISTCONTROL="ignoreboth" #ignoreboth will ignore consecutive dups and commands starting with space
export HISTTIMEFORMAT="${TEXT_BLUE}%F %T${RESET_FORMATTING} "
export HISTIGNORE="hist*:ls:pwd:g l:g st:g dif:rhq:rhqGui:runPostgres:bash"
export HISTSIZE="1000000"
export HISTFILESIZE="1000000"

history() {
  _bash_history_sync
  builtin history "$@"
}

function histgrep() { fc -l -$((HISTSIZE-1)) | egrep "$@" ;}

function topCmd() { history | awk '{ print $4 }' | sort | uniq -c | sort -rn | head $@;}
alias top10="topCmd"
alias top20="topCmd -20"
alias top50="topCmd -50"

alias vbash="vim ~/.bashrc"
alias vibash="vbash"
alias vimbash="vbash"

#docker
alias d="docker"
complete -F _docker_compose d
alias dc="docker-compose"
complete -F _docker_compose dc
dockerCleanup(){
  d kill `d ps -aq`
  d rm -f `d ps -aq`
  d rmi -f `d images -qa`
  d volume rm `d volume ls -q`
  d network rm `d network ls -q`

  # removing images that can't be removed ("Error response from daemon: reference does not exist")
  sudo rm -Rf /var/lib/docker/image/devicemapper/imagedb/content/sha256 && sudo mkdir /var/lib/docker/image/devicemapper/imagedb/content/sha256

  # this helps if it's saying the port is already allocated even though it's not
  sudo rm /var/lib/docker/network/files/*
  sudo systemctl restart docker
}
alias dCleanup="dockerCleanup"

alias ap="ansible-playbook"

_bash_history_sync() {
  CODE=$?
  builtin history -a         #1
  HISTFILESIZE=$HISTSIZE     #2
  builtin history -c         #3 comment out 3 and 4 if you don't want to share last commands across terminal sessions
  builtin history -r         #4
  promptText $CODE
}

PROMPT_COMMAND=_bash_history_sync

shopt -s histappend # append to history, don't overwrite it
shopt -s histreedit # reedit a history substitution line if it failed
shopt -s histverify # edit a recalled history line before executing
#PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND" # Save and reload the history after each command finishes

# don't complete if there is no command
# shopt -s no_empty_cmd_com­pletion

export EDITOR="vim"
export GREP_COLOR="0;31"
type most &> /dev/null && export PAGER="most"


# wrap the text content on the screen
#export LESS="-FerX"

# syntax highlight in less (assumes the source-highlight package to be installed)
export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
export LESS=' -R '

#JAVA_HOME
[[ "x$JDK_VER" == "x6" ]] && export JAVA_HOME="$HOME/install/jdk1.6.0_45"
[[ "x$JDK_VER" == "x7" ]] && export JAVA_HOME="$HOME/install/jdk1.7.0_79"
[[ "x$JDK_VER" == "x8" ]] && export JAVA_HOME="$HOME/install/jdk1.8.0_144"
[[ "x$JDK_VER" == "x87" ]] && export JAVA_HOME="$HOME/install/jdk1.8.0_74"
[[ "x$JDK_VER" == "x" ]] && export JAVA_HOME="$HOME/install/jdk1.8.0_144"

#export JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk"

# simple jdk switcher
jdk() {
  [[ "x$1" == "x6" ]] && echo "jdk 6" && JDK_VER="6" bash
  [[ "x$1" == "x7" ]] && echo "jdk 7" && JDK_VER="7" bash
  [[ "x$1" == "x8" ]] && echo "jdk 8" && JDK_VER="87" bash
  [[ "x$1" == "x" ]] && echo "no jdk version specified, defaults to jdk 8" && JDK_VER="8" bash
}

alias profilingOn="export JAVA_OPTS=\"$JAVA_OPTS -Djboss.modules.system.pkgs=com.jprofiler -agentlib:jprofilerti=port=8849 -Xbootclasspath/a:/home/jkremser/install/jprofiler9/bin/agent.jar\" export LD_LIBRARY_PATH=\"/home/jkremser/install/jprofiler9/bin/linux-x64\""
alias profilingOff="export JAVA_OPTS=\"\" export LD_LIBRARY_PATH=\"\""

export M2_HOME="$HOME/install/apache-maven-3.5.0"
export MAVEN_OPTS="-Xms256M -Xmx768M -XX:ReservedCodeCacheSize=96M"
# add permgen jvm options for jdk 7 and lower
[[ $("$JAVA_HOME/bin/java" -version 2>&1 | awk -F '"' '/version/ {print $2}') > "1.8" ]] || export MAVEN_OPTS="$MAVEN_OPTS -XX:PermSize=128M -XX:MaxPermSize=256M"
export FORGE_HOME="$HOME/install/forge"
export SBT_OPTS="-Xms1336m -Xmx1336m"

# <$PATH stuff>
_addToPath() {
  if [[ $# != 1 ]] && [[ $# != 2 ]]; then
     echo "Usage: _addToPath /bin/foo" && exit
  fi
  local _to_add=$1
  # must be a directory, must be an absolute path, $PATH must not contain it
  if [[ -d "${_to_add}" ]] && [[ "${_to_add}" = /* ]] && [[ $PATH != *"${_to_add}"* ]]; then
    if [[ $# != 2 ]]; then
      export PATH="$PATH:$_to_add"
    else
      export PATH="$_to_add:$PATH"
    fi
  fi
}

_addToPath "$M2_HOME/bin"
_addToPath "$WORKSPACE/miq-helpers"
_addToPath "$HOME/.rvm/bin"
_addToPath "$HOME/install/sbt-launcher-packaging-0.13.13/bin"
#_addToPath "$HOME/.rvm/bin" "toTheBegining"
#_addToPath "/bin/foo"

HADOOP_HOME="/home/jkremser/install/hadoop-2.2.0"
_addToPath "$HADOOP_HOME/bin"

# </$PATH stuff>

export CATALINA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=8999 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=localhost";

# C*
export MAX_HEAP_SIZE="512M"
export HEAP_NEWSIZE="128M"

export GOPATH=/home/jkremser/install/go-workspace

export WINEARCH=win32

# added by travis gem
[ -f /home/jkremser/.travis/travis.sh ] && source /home/jkremser/.travis/travis.sh

. ~/.personal.sh
#. ~/.ruby-fu.sh

#export VAGRANT_DEFAULT_PROVIDER=virtualbox
export GOPATH=$HOME/go
