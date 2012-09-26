# .bashrc (Jiri Kremser)

# packages needed: pv ngrep tcpdump

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
# User specific aliases and functions

export HISTTIMEFORMAT="%y-%d-%m %H:%M:%S "


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
PS1='[\u@\h \W\[\033[01;32m\]$(__git_ps1 " git:%s")\[\033[00m\]]\$ '
PS1="\[\033[G\]$PS1"

#to retain history across multiple open sessions to the same system
shopt -s histappend


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

# Make box around text.
box() { t="$1xxxx";c=${2:-=}; echo ${t//?/$c}; echo "$c $1 $c"; echo ${t//?/$c}; }
alias box=box

#melodyping(){ ping $1|awk -F[=\ ] '/me=/{t=$(NF-1);f=3000-14*log(t^20);c="play -q -n synth 0.7s pl " f;print $0;system(c)}';}

#aliases
# View HTTP traffic
alias sniff="sudo ngrep -d 'em1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i em1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

alias g="git "
alias update="g stash && g pull --rebase && g stash pop"

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

#vpn
alias vpnVsup='sudo /etc/init.d/openvpn stop && sleep 1 && sudo cp /etc/openvpn/client.conf_vsup /etc/openvpn/client.conf && sudo /etc/init.d/openvpn start'
alias vpnMzk='sudo /etc/init.d/openvpn stop && sleep 1 && sudo cp /etc/openvpn/client.conf_mzk /etc/openvpn/client.conf && sudo /etc/init.d/openvpn start'

# Quick search in a directory for a string
alias search="ack -i "

#places
alias bup='ssh kremser@10.102.0.1'
alias wor='ssh kremser@10.2.3.105'

export WORKSPACE="$HOME/workspace"
alias rhq="cd $WORKSPACE/rhq && pwd"
alias rhqGui="cd $WORKSPACE/rhq/modules/enterprise/gui/coregui && pwd"


#rhq
RHQ_VERSION="4.6.0"
alias runPostgres="sudo service postgresql start"
alias runServer="$WORKSPACE/rhq/dev-container/bin/rhq-server.sh console"
alias runCompileAndServer="mvn clean -Penterprise,dev -DskipTests install && runServer"
alias runAgent=" $WORKSPACE/rhq/dev-container/jbossas/server/default/deploy/rhq.ear/rhq-downloads/rhq-agent/rhq-agent/bin/rhq-agent.sh"
alias runAgentInstalation="cd $WORKSPACE/rhq/dev-container/jbossas/server/default/deploy/rhq.ear/rhq-downloads/rhq-agent/ && java -jar $WORKSPACE/rhq/dev-container/jbossas/server/default/deploy/rhq.ear/rhq-downloads/rhq-agent/rhq-enterprise-agent-$RHQ_VERSION-SNAPSHOT.jar --install && cd -"
alias runCli="$WORKSPACE/rhq/modules/enterprise/remoting/cli/target/rhq-remoting-cli-$RHQ_VERSION-SNAPSHOT/bin/rhq-cli.sh"
alias agentLog="tail -f $WORKSPACE/rhq/dev-container/jbossas/server/default/deploy/rhq.ear/rhq-downloads/rhq-agent/rhq-agent/logs/agent.log"


#env
export HISTCONTROL="ignoreboth"
export HISTSIZE="100000"
export HISTFILESIZE="100000"
export EDITOR="vim"
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="0;31"

# wrap the text content on the screen
#export LESS="-FerX"

export RHQ_SERVER_ADDITIONAL_JAVA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n"
export RHQ_AGENT_ADDITIONAL_JAVA_OPTS='-Xdebug -Xrunjdwp:transport=dt_socket,address=9797,server=y,suspend=n'
export RHQ_SERVER_DEBUG="true"
export JAVA_HOME="$HOME/install/jdk1.6.0_31"
export M2_HOME="$HOME/install/apache-maven-3.0.4"
export MAVEN_OPTS="-Xms256M -Xmx768M -XX:PermSize=128M -XX:MaxPermSize=256M -XX:ReservedCodeCacheSize=96M"
#export HADOOP_HOME="$HOME/install/hadoop-1.0.3"
export FORGE_HOME="$HOME/install/forge/"
export PATH="$FORGE_HOME/bin:$M2_HOME/bin:$JAVA_HOME/bin:$HOME/install/sbt/bin:$PATH"
export CATALINA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=8999 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=localhost";

#export HADOOP_LOG_DIR=$HADOOP_HOME/log
