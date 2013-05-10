# .bashrc (Jiri Kremser)

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#git cmd line branch highlighting
GIT_VERSION=`rpm -q --qf "%{VERSION}" git`
. /usr/share/doc/git-"$GIT_VERSION"/contrib/completion/git-completion.bash
#parse_svn_url() {
#     svn info 2>/dev/null | grep -e '^URL*' | sed -e 's#^URL: *\(.*\)#\1#g '
#}
#parse_svn_repository_root() {
#     svn info 2>/dev/null | grep -e '^Repository Root:*' | sed -e 's#^Repository Root: *\(.*\)#\1\/#g '
#}
#parse_svn_branch() {
#     parse_svn_url | sed -e 's#^'"$(parse_svn_repository_root)"'##g' | awk -F / '{print " svn:" $0}'
#}
#PS1='[\u@\h \W\[\033[01;32m\]$(__git_ps1 " git:%s")$(parse_svn_branch)\[\033[00m\]]\$ '
PS1='[\u@\h \W\[\033[0;32m\]$(__git_ps1 " %s")\[\033[00m\]]\$ '
PS1="\[\033[G\]$PS1"

rpick(){
  echo $@ | tr ',' '\n' | tr ' ' '\n' | sort -R | head -1
}

mywhich(){
  readlink -f $( which $1 )
}

mybcp(){
  cp $1{,-$( date +%F )}
}

mylog(){
  less +F $1 |egrep --line-buffered --color=auto 'ERROR|WARN|$' # tail log & highlight errors (if your grep supports --color)
}

myRunAgents(){
  cd $WORKSPACE/rhq/etc/agentspawn/target/
  java -jar -Dperftest.spawncount=$1 org.rhq.agentspawn-1.0-SNAPSHOT.jar start
  cd -
}

myCertAdd(){
  certutil -d sql:$HOME/.pki/nssdb -A -t "P,," -n $1 -i $1
}


##### </Maven colors>
# Mvn color (https://gist.github.com/1027800) 
# Formatting constants
export BOLD=`tput bold`
export UNDERLINE_ON=`tput smul`
export UNDERLINE_OFF=`tput rmul`
export TEXT_BLACK=`tput setaf 0`
export TEXT_RED=`tput setaf 1`
export TEXT_GREEN=`tput setaf 2`
export TEXT_YELLOW=`tput setaf 3`
export TEXT_BLUE=`tput setaf 4`
export TEXT_MAGENTA=`tput setaf 5`
export TEXT_CYAN=`tput setaf 6`
export TEXT_WHITE=`tput setaf 7`
export BACKGROUND_BLACK=`tput setab 0`
export BACKGROUND_RED=`tput setab 1`
export BACKGROUND_GREEN=`tput setab 2`
export BACKGROUND_YELLOW=`tput setab 3`
export BACKGROUND_BLUE=`tput setab 4`
export BACKGROUND_MAGENTA=`tput setab 5`
export BACKGROUND_CYAN=`tput setab 6`
export BACKGROUND_WHITE=`tput setab 7`
export RESET_FORMATTING=`tput sgr0`
 
# Wrapper function for Maven's mvn command.
mvnColor() {
  mvn $@ | sed -e "s/\(\[INFO\]\ \[.*\)/${RESET_FORMATTING}\1${RESET_FORMATTING}/g" \
               -e "/\[INFO\]\ Building\ \(war\:\|jar\:\|ear\:\)/! s/\(\[INFO\]\ Building .*\)/${TEXT_BLUE}\1${RESET_FORMATTING}/g" \
               -e "s/\(\[INFO\]\ BUILD SUCCESSFUL\)/${TEXT_GREEN}\1${RESET_FORMATTING}/g" \
               -e "s/\(\[WARNING\].*\)/${TEXT_YELLOW}\1${RESET_FORMATTING}/g" \
               -e "s/\(\[ERROR\].*\)/${TEXT_RED}\1${RESET_FORMATTING}/g" \
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
           -e "s/\(Caused by: .*\)/${BOLD}${TEXT_RED}\1${RESET_FORMATTING}/g"
}

# Make box around text.
box() { t="$1xxxx";c=${2:-=}; echo ${t//?/$c}; echo "$c $1 $c"; echo ${t//?/$c}; }
alias box=box

# make nice commit log output for BugZilla
myGll() {
  BRANCH=`git rev-parse --abbrev-ref HEAD 2> /dev/null | tr '/' '#@#'`
  git l5-helper | sed -e "s/%REPLACE%/${BRANCH}/" -e "s/#@#/\\//"
}

#melodyping(){ ping $1|awk -F[=\ ] '/me=/{t=$(NF-1);f=3000-14*log(t^20);c="play -q -n synth 0.7s pl " f;print $0;system(c)}';}

#aliases
# View HTTP traffic
alias sniff="sudo ngrep -d 'em1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i em1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# git
alias g="git "
alias gl="g l"
alias gll="myGll"
alias gst="g st"
alias gpl="g pl"
alias gd="g dif"
alias gdf="gd"
alias gap="g ap"

# bash completion working with the 'g' alias
complete -o default -o nospace -F _git g

# ignore some patterns during bash completion
export FIGNORE=.bat:.svn
bind 'set match-hidden-files off'

alias dlna="/home/jkremser/install/pms-1.72.0/PMS.sh"

# Start a web service on port 8000 that uses CWD as its document root.
alias share="python -m SimpleHTTPServer"

#randomly selects one of its arguments
alias pick=rpick

#which follows symlinks
alias wh=mywhich

#Show a count of how many normal files are in the current directory and below.
alias fileNumber="find . -type f | wc -l"

#backup
alias bcp=mybcp

#sudo
alias s=sudo

#yum
alias yi="sudo yum install"
alias ys="sudo yum search"

alias log=mylog

#top on steroids
alias top="htop"

# Complement to whoami command.
alias whereami='echo "$( hostname --fqdn ) ($(hostname -i)):$( pwd )"'
#alias neco="melodyping"

alias rtfm="echo '16i[q]sa[ln0=aln100%Pln100/snlbx]sbA0D4D465452snlbxq' | dc"

#play short sounds
alias soundCow="paplay /usr/lib/libreoffice/share/gallery/sounds/cow.wav"
alias soundHorse="paplay /usr/lib/libreoffice/share/gallery/sounds/horse.wav"
alias soundTrain="paplay /usr/lib/libreoffice/share/gallery/sounds/train.wav"

#vpn
alias vpnVsup='sudo /etc/init.d/openvpn stop && sleep 1 && sudo cp /etc/openvpn/client.conf_vsup /etc/openvpn/client.conf && sudo /etc/init.d/openvpn start'
alias vpnMzk='sudo /etc/init.d/openvpn stop && sleep 1 && sudo cp /etc/openvpn/client.conf_mzk /etc/openvpn/client.conf && sudo /etc/init.d/openvpn start'

#cert
alias certAdd="myCertAdd"
alias certList="certutil -d sql:$HOME/.pki/nssdb -L" # add '-h all' to see all built-in certs"

# Quick search in a directory for a string
alias search="ack -i "

#rhq
export WORKSPACE="$HOME/workspace"
export RHQ_HOME="$WORKSPACE/rhq"
alias rhq='cd $WORKSPACE/rhq && echo ${TEXT_CYAN} && figlet RHQ && echo ${RESET_FORMATTING} && echo "Current directory is:" && pwd'
alias rhqGui='cd $WORKSPACE/rhq/modules/enterprise/gui/coregui && echo ${TEXT_MAGENTA} && figlet coregui && echo ${RESET_FORMATTING} && echo "Current directory is:" && pwd'

RHQ_VERSION="4.7.0"
RHQ_AGENT_HOME="$HOME/agent"
RHQ_AGENT_INSTALL_DIR="$RHQ_AGENT_HOME/rhq-agent"
#RHQ_AGENT_HOME="$WORKSPACE/rhq/dev-container/jbossas/standalone/deployments/rhq.ear/rhq-downloads/rhq-agent/rhq-agent"

alias runPostgres="sudo service postgresql start"
alias runServer="logColor $RHQ_HOME/dev-container/bin/rhq-server.sh"
alias ctl="logColor rhqctl"
#alias runSer="runServer console"
alias runSer="ctl console --server"
alias runAgent="$RHQ_AGENT_INSTALL_DIR/bin/rhq-agent.sh"
alias runAgentInstalation="cd $RHQ_AGENT_HOME && wget -O latest-agent.jar http://localhost:7080/agentupdate/download && java -jar $RHQ_AGENT_HOME/latest-agent.jar --install && cd -"
alias runAgents="myRunAgents"
alias runCli="$RHQ_HOME/modules/enterprise/remoting/cli/target/rhq-remoting-cli-$RHQ_VERSION-SNAPSHOT/bin/rhq-cli.sh"
alias runCliLogin="runCli --user rhqadmin --password  rhqadmin"
alias agentLog="logColor tail -f $RHQ_AGENT_INSTALL_DIR/logs/agent.log"
alias serverLog="logColor tail -f $RHQ_HOME/dev-container/logs/server.log"

alias hist="history -r; history"

#env
#history on steroids
export HISTCONTROL="ignoreboth" #ignoreboth will ignore consecutive dups and commands starting with space
export HISTTIMEFORMAT="${TEXT_BLUE}%F %T${RESET_FORMATTING} "
export HISTIGNORE="hist*:ls:pwd:g l:g st:g dif:rhq:rhqGui:runPostgres:bash"
export HISTSIZE="1000000"
export HISTFILESIZE="1000000"

shopt -s histappend # append to history, don't overwrite it
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND" # Save and reload the history after each command finishes

export EDITOR="vim"
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="0;31"

# wrap the text content on the screen
#export LESS="-FerX"

export RHQ_SERVER_ADDITIONAL_JAVA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n"
export RHQ_AGENT_ADDITIONAL_JAVA_OPTS='-Xdebug -Xrunjdwp:transport=dt_socket,address=9797,server=y,suspend=n'
export RHQ_SERVER_DEBUG="false"

#JAVA_HOME
export JAVA_HOME="$HOME/install/jdk1.7.0_09"
#export JAVA_HOME="$HOME/install/jdk1.6.0_31"
#export JAVA_HOME="/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.9/"

export M2_HOME="$HOME/install/apache-maven-3.0.4"
export MAVEN_OPTS="-Xms256M -Xmx768M -XX:PermSize=128M -XX:MaxPermSize=256M -XX:ReservedCodeCacheSize=96M"
#export HADOOP_HOME="$HOME/install/hadoop-1.0.3"
export FORGE_HOME="$HOME/install/forge/"
export GWT_HOME="$HOME/install/gwt-2.5.1/"
export PATH="$RHQ_HOME/dev-container/bin:$RHQ_HOME/dev-container/bin:/opt/vagrant/bin:$FORGE_HOME/bin:$M2_HOME/bin:$JAVA_HOME/bin:$HOME/install/sbt/bin:$PATH"
# rhq ant bundle deployer
export PATH="$RHQ_HOME/modules/common/ant-bundle/target/rhq-bundle-deployer-$RHQ_VERSION-SNAPSHOT/bin:$PATH"
export CATALINA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=8999 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=localhost";

# C*
export MAX_HEAP_SIZE="512M"
export HEAP_NEWSIZE="128M"

#export HADOOP_LOG_DIR=$HADOOP_HOME/log
