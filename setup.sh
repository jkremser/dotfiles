#!/bin/bash


gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 20
gsettings set org.gnome.desktop.peripherals.keyboard delay 300

for i in $(ls -A); do
  [ "README" != $i ] && [ ".git" != $i ] && [[ $0 != *$i ]] &&  {
    echo copying $i to ~
    cp -r $i ~
  }
done
