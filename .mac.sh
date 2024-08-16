#!/usr/bin/env bash

# home and end buttons on magic keyboards
# https://ke-complex-modifications.pqrs.org/#HomeEnd

url(){
  cat <<EOF | osascript 
tell application "Google Chrome" to return URL of active tab of front window
EOF
}

sp3(){
  [[ $# -lt 4 ]] && echo "usage: sp3 command arg1 arg2 arg3" && return
  command=$1
  arg1=$2
  arg2=$3
  arg3=$4
  sp2 $command $arg1 $arg2
  cat <<EOF | osascript
tell application "iTerm"
    activate
    set W to current window
    if W = missing value then set W to create window with default profile
    tell W's current session
        split vertically with default profile
    end tell
    set T to W's current tab
    write T's session 2 text "$comamnd $arg3"
end tell
EOF
}


sp2(){
  [[ $# -lt 3 ]] && echo "usage: sp2 command arg1 arg2" && return
  command=$1
  arg1=$2
  arg2=$3
  cat <<EOF | osascript
tell application "iTerm"
    activate
    set W to current window
    if W = missing value then set W to create window with default profile
    tell W's current session
        split vertically with default profile
    end tell
    set T to W's current tab
    write T's session 1 text "$command $arg1"
    write T's session 2 text "$command $arg2"
end tell
EOF
}
