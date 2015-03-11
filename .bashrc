# .bashrc (Jiri Kremser)

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#git cmd line branch highlighting
. /usr/share/doc/git/contrib/completion/git-completion.bash
#parse_svn_url() {
#     svn info 2>/dev/null | grep -e '^URL*' | sed -e 's#^URL: *\(.*\)#\1#g '
#}
#parse_svn_repository_root() {
#     svn info 2>/dev/null | grep -e '^Repository Root:*' | sed -e 's#^Repository Root: *\(.*\)#\1\/#g '
#}
#parse_svn_branch() {
#     parse_svn_url | sed -e 's#^'"$(parse_svn_repository_root)"'##g' | awk -F / '{print " svn:" $0}'
#}
promptText() {    
  CODE=$?;
  CODE_STR="";
  GITBRANCH=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/');
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
  PS1="[\u@\h \W$GREEN $GITBRANCH$NORMAL]";
  PS1="\[\033[G\]$PS1$RED$CODE_STR$NORMAL\$ ";
}
#export PROMPT_COMMAND=promptText

#PS1='[\u@\h \W\[\033[0;32m\]$(__git_ps1 " %s")\[\033[00m\]]\$ '
#PS1="\[\033[G\]$PS1"

pick(){
  echo $@ | tr ',' '\n' | tr ' ' '\n' | sort -R | head -1
}

mywhich(){
  readlink -f $( which $1 )
}

bcp(){
  cp $1{,-$( date +%F )}
}

mylog(){
  less +F $1 |egrep --line-buffered --color=auto 'ERROR|WARN|$' # tail log & highlight errors (if your grep supports --color)
}

runAgents(){
  cd $WORKSPACE/rhq/etc/agentspawn/target/
  java -jar -Dperftest.spawncount=$1 org.rhq.agentspawn-1.0-SNAPSHOT.jar start
  cd -
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
               -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/${BOLD}${TEXT_GREEN}Tests run: \1${RESET_FORMATTING}, Failures: ${BOLD}${TEXT_RED}\2${RESET_FORMATTING}, Errors: ${BOLD}${TEXT_RED}\3${RESET_FORMATTING}, Skipped: ${BOLD}${TEXT_YELLOW}\4${RESET_FORMATTING}/g"
  echo -ne ${RESET_FORMATTING}
}
alias mvn="mvnColor"
##### </Maven colors>


logColor() {
  echo $@
  [ $# = 0 ] && exit
  $@ | sed -e "s/\(\ INFO\ \ .*\)/${RESET_FORMATTING}\1${RESET_FORMATTING}/g" \
           -e "s/\(\ WARN\ \ .*\)/${TEXT_YELLOW}\1${RESET_FORMATTING}/g" \
           -e "s/\(\ ERROR\ .*\)/${TEXT_RED}\1${RESET_FORMATTING}/g" \
           -e "s/\(org\.rhq\..*\)/${BOLD}\1${RESET_FORMATTING}/g" \
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

function vim {
  local target="$1"
  [[ $target == ~?* ]] && target="~/${target:2}"
  eval "/usr/bin/vim ${target}"
  return $?
}

#melodyping(){ ping $1|awk -F[=\ ] '/me=/{t=$(NF-1);f=3000-14*log(t^20);c="play -q -n synth 0.7s pl " f;print $0;system(c)}';}

#aliases

# View HTTP traffic
alias sniff="sudo ngrep -d 'em1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i em1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# git
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

# cd
alias ..='cd ..'
alias ...='cd ../../../'

# https://github.com/vigneshwaranr/bd
alias bd=". bd -s"

# safe rm
alias rm='rm --preserve-root'

# netstat
alias ports='netstat -tulanp'

# bash completion working with the 'g' alias
complete -o default -o nospace -F _git g

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

#which follows symlinks
alias wh=mywhich

#Show a count of how many normal files are in the current directory and below.
alias fileNumber="find . -type f | wc -l"

#sudo
alias s=sudo
alias plz=sudo

#yum
alias yi="sudo yum install"
alias ys="sudo yum search"

alias log=mylog
alias syslogs='s tail -f -n5 $(find /var/log -name \*log)'

#top on steroids
alias top="htop"

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

# phone
alias n4mount="simple-mtpfs ~/Nexus4"
alias n4umount="fusermount -u ~/Nexus4"

#rhq
export WORKSPACE="$HOME/workspace"
export RHQ_HOME="$WORKSPACE/rhq"
alias rhq='cd $WORKSPACE/rhq && echo ${TEXT_CYAN} && figlet RHQ && echo ${RESET_FORMATTING} && echo "Current directory is:" && pwd'
alias rhqGui='cd $WORKSPACE/rhq/modules/enterprise/gui/coregui && echo ${TEXT_MAGENTA} && figlet coregui && echo ${RESET_FORMATTING} && echo "Current directory is:" && pwd'
alias rtl="rhqctl"
complete -o default -o nospace -F _rhqctl rtl

#hawkular
alias hawk='cd $WORKSPACE/hawkular && echo ${TEXT_HAWKULARBLUE} && figlet HAWKULAR && echo ${RESET_FORMATTING} && echo "Current directory is:" && pwd'

RHQ_VERSION="4.13.0"
RHQ_AGENT_HOME="$RHQ_HOME/dev-container/rhq-agent/"
RHQ_AGENT_INSTALL_DIR="$RHQ_AGENT_HOME"
#RHQ_AGENT_HOME="$WORKSPACE/rhq/dev-container/jbossas/standalone/deployments/rhq.ear/rhq-downloads/rhq-agent/rhq-agent"

alias runPostgres="sudo service postgresql start"
alias ctl="logColor rhqctl"
#alias runSer="runServer console"
alias runSer="ctl console --server"
alias runAgent="$RHQ_AGENT_INSTALL_DIR/bin/rhq-agent.sh"
alias runAgentInstalation="cd $RHQ_AGENT_HOME && wget -O latest-agent.jar http://localhost:7080/agentupdate/download && java -jar $RHQ_AGENT_HOME/latest-agent.jar --install && cd -"
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

alias webcam="ssh jkremser@192.168.1.100 -Y 'mplayer tv://device=/dev/video0'"

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

_bash_history_sync() {
  builtin history -a         #1
  HISTFILESIZE=$HISTSIZE     #2
  builtin history -c         #3 comment out 3 and 4 if you don't want to share last commands across terminal sessions
  builtin history -r         #4
  promptText  
}

PROMPT_COMMAND=_bash_history_sync

shopt -s histappend # append to history, don't overwrite it
shopt -s histreedit # reedit a history substitution line if it failed
shopt -s histverify # edit a recalled history line before executing
#PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND" # Save and reload the history after each command finishes

# don't complete if there is no command
# shopt -s no_empty_cmd_com­pletion

export EDITOR="vim"
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="0;31"

# wrap the text content on the screen
#export LESS="-FerX"

# syntax highlight in less (assumes the source-highlight package to be installed)
export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
export LESS=' -R '

export RHQ_SERVER_ADDITIONAL_JAVA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n"
export RHQ_AGENT_ADDITIONAL_JAVA_OPTS='-Xdebug -Xrunjdwp:transport=dt_socket,address=9797,server=y,suspend=n'
#pre-rhqctl epoch
#export RHQ_SERVER_DEBUG="true"
export RHQ_AGENT_DEBUG="true"
#export RHQ_CONTROL_DEBUG="true"

#JAVA_HOME
[[ "x$JDK_VER" == "x7" ]] && export JAVA_HOME="$HOME/install/jdk1.7.0_71"
[[ "x$JDK_VER" == "x8" ]] && export JAVA_HOME="$HOME/install/jdk1.8.0_25"
[[ "x$JDK_VER" == "x" ]] && export JAVA_HOME="$HOME/install/jdk1.8.0_25"

# simple jdk switcher
jdk() {
  [[ "x$1" == "x7" ]] && echo "jdk 7" && JDK_VER="7" bash
  [[ "x$1" == "x8" ]] && echo "jdk 8" && JDK_VER="8" bash
  [[ "x$1" == "x" ]] && echo "no jdk version specified, defaults to jdk 8" && JDK_VER="8" bash
}

export M2_HOME="$HOME/install/apache-maven-3.2.3"
#export GRADLE_HOME="$HOME/install/gradle-2.2.1"
export GRADLE_HOME="$HOME/install/android-studio/gradle/gradle-2.2.1"
#export M2_HOME="$HOME/install/apache-maven-2.2.1"

export MAVEN_OPTS="-Xms256M -Xmx768M -XX:ReservedCodeCacheSize=96M"
# add permgen jvm options for jdk 7 and lower
[[ $("$JAVA_HOME/bin/java" -version 2>&1 | awk -F '"' '/version/ {print $2}') > "1.8" ]] || export MAVEN_OPTS="$MAVEN_OPTS -XX:PermSize=128M -XX:MaxPermSize=256M"
#export HADOOP_HOME="$HOME/install/hadoop-1.0.3"
export FORGE_HOME="$HOME/install/forge"
export JBAKE_HOME="$HOME/install/jbake-2.3.2"
export GWT_HOME="$HOME/install/gwt-2.5.1"
export ANDROID_SDK_HOME="$HOME/install/adt-bundle-linux-x86_64-20140702/sdk"
export ANDROID_HOME="$ANDROID_SDK_HOME"
export SCALA_HOME="$HOME/install/scala-2.10.2"
export VERTEX_HOME="$HOME/install/vert.x-2.1M2"
export SBT_OPTS="-Xms1336m -Xmx1336m"
export PATH="$HOME/install/os/:$JBAKE_HOME/bin:$HOME/install/apache-ant-1.9.4/bin:$HOME/install/gradle-2.0/bin:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools:$SCALA_HOME/bin:$RHQ_HOME/dev-container/rhq-server/bin:/opt/vagrant/bin:$FORGE_HOME/bin:$M2_HOME/bin:$GRADLE_HOME/bin:$JAVA_HOME/bin:$HOME/install/sbt/bin:$VERTEX_HOME/bin:$PATH"
# rhq ant bundle deployer
export PATH="$HOME/install/android-ndk-r10d:$HOME/install//node-v0.10.22-linux-x86/bin:$PATH"
export PATH="$RHQ_HOME/modules/common/ant-bundle/target/rhq-bundle-deployer-$RHQ_VERSION-SNAPSHOT/bin:$PATH"
export PATH="$HOME/install/openshift-origin/_output/local/go/bin:$PATH"
export CATALINA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=8999 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=localhost";

# C*
export MAX_HEAP_SIZE="512M"
export HEAP_NEWSIZE="128M"

export GOPATH=/home/jkremser/install/go-workspace

export WINEARCH=win32

# The next line enables bash completion for gcloud.
source '/home/jkremser/install/google-cloud-sdk/completion.bash.inc'

# added by travis gem
[ -f /home/jkremser/.travis/travis.sh ] && source /home/jkremser/.travis/travis.sh
