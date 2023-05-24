#!/bin/bash

gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 20
gsettings set org.gnome.desktop.peripherals.keyboard delay 300

for i in $(ls -A); do
  [ "README" != $i ] && [ ".git" != $i ] && [[ $0 != *$i ]] &&  {
    echo copying $i to ~
    cp -r $i ~
  }
done

if [[ "$OSTYPE" == "darwin"* ]]; then
  # remove that annoying 'Last login..' msg
  touch ~/.hushlogin 
  mkdir ~/bin || true
fi

# gpg in .gitconfig
set -o pipefail
signingkey=$(gpg --list-secret-keys --keyid-format LONG | grep sec | head -1 | cut -d'/' -f2 | cut -d' ' -f1)
code=$?
[[ "$code" -eq 0 ]] &&  sed -i'' -e "s;\(signingkey = \).*;\1$signingkey;g" ~/.gitconfig
set +o pipefail



#cp -r .dotfiles ~/.dotfiles
