#!/usr/bin/env bash

gpl() {
  git pull --rebase origin master || { echo "trying 'main'.." && git pull --rebase origin main }
}

gShowPr() {
  [[ "x$1" == "x" ]] || git fetch origin pull/$1/head:pr$1 && g cd pr$1
}

prs() {
  _PR_NUM=$(gh pr list | cut -f -2 | fzf --header "Select PR to checkout" --ansi --cycle --preview-window bottom:70% --preview "gh pr diff --color=always {1}" | cut -f1)
   git fetch origin pull/${_PR_NUM}/head:pr${_PR_NUM} && git checkout pr${_PR_NUM}
}

cleanBranches() {
  _TO_DELETE=$(g ls | grep -v " master$" | fzf -m --tac --no-sort --header "Use Shift+Tab to select multiple branches to delete" | cut -d' ' -f2)
  [[ "x$_TO_DELETE" == "x" ]] || {
    echo -e "selected branches:\n$(echo $_TO_DELETE | sed 's/^\s\?/- /g')\n"
    read "ans?Are you sure you want to delete them? $TEXT_RED<y/n>$RESET_FORMATTING "
    [[ $ans == "y" ]] && for b in `echo $_TO_DELETE`; do git branch -D $b; done;
  }
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
  git remote -v | head -1 | grep '//github.com/' && { # origin cloned as https://github.com
    G_REMOTE=`git remote -v | head -1 | sed 's;.*://github.com/[^/]*\([^\ ]*\).*;git@github.com:jkremser\1;g'` || true
  } || { # origin cloned as git@github.com
    G_REMOTE=`git remote -v | head -1 | sed 's;.*git@github.com:[^/]\{2,\}\(\S*\).*;git@github.com:jkremser\1;g'`
  }
  g remote add personal $G_REMOTE
  gh repo fork
}
