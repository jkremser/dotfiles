#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

for i in $(ls -A); do
  [ "README" != $i ] && [ ".git" != $i ] && [[ $0 != *$i ]] &&  {
    echo copying $i to ~
    cp -r $i ~
  }
done


if [[ "$OSTYPE" == "darwin"* ]]; then
  # remove that annoying 'Last login..' msg
  touch ~/.hushlogin
fi