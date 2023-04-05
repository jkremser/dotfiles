#!/usr/bin/env bash

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

function calc() {

    local result=""

    #                       ┌─ default (when --mathlib is used) is 20
    result="$( printf "scale=10;%s\n" "$*" | bc --mathlib | tr -d "\\\n" )"
    #                         remove the tailing "\" and "\n" ─┘
    #                         (large numbers are printed on multiple lines)

    if [[ "$result" == *.* ]]; then

        # Improve the output for decimal numbers.

        printf "%s" "$result" | sed -e "s/^\./0./" -e "s/^-\./-0./" -e "s/0*$//;s/\.$//"

    else
        printf "%s" "$result"
    fi

    printf "\n"

}

function digg() {
    dig +nocmd "$1" any +multiline +noall +answer;
}

sayCWD() {
  [[ "x$1" == "x" ]] || echo ${TEXT_HAWKULARBLUE} && figlet -f ~/ogre.flf -m8 $1 && echo ${RESET_FORMATTING} && echo "Current directory is:" && pwd
}
