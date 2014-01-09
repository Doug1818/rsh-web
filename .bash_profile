export PATH=/usr/local/bin:$PATH
export EDITOR=slime

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function proml {
  local        BLUE="\[\033[0;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local      YELLOW="\[\033[0;33m\]"
  local       WHITE="\[\033[0;37m\]"
  local        CYAN="\[\033[0;36m\]"
  case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\u@\h:\w\007\]'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac


PS1="${TITLEBAR}\
$BLUE[$CYAN\$(date +%H:%M)$BLUE]\
$BLUE[$CYAN\u\w$GREEN\$(parse_git_branch)$BLUE]\
$GREEN\$ "
PS2='> '
PS4='+ '
}
proml

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
cd ~/workspace/rsh-web/

set -o emacs

PATH=usr/local/bin:$PATH
export PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

alias slime='open -a "/Applications/Sublime Text 2.app"'
alias bp='slime ~/.bash_profile'
alias ll='ls -la'
alias glf='git log --pretty=format:'\''%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s'\'' --date=local --graph'
alias mvim='open -a   "/Applications/MacVim.app"'
##
# Your previous /Users/dr/.bash_profile file was backed up as /Users/dr/.bash_profile.macports-saved_2012-07-16_at_14:11:06
##

# MacPorts Installer addition on 2012-07-16_at_14:11:06: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

