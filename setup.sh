#!/bin/bash
for i in $(ls -A); do
  [ "README" != $i ] && [ ".git" != $i ] && [[ $0 != *$i ]] &&  {
    echo copying $i to ~
    cp -r $i ~
  }
done
