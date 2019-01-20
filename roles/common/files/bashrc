# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# append to the history file, don't overwrite it
shopt -s histappend

# don't put duplicate lines in the history - ignoredups and ignorespace
# and erase duplicates
HISTCONTROL="ignoreboth:erasedups"

# set the number of commands to remember in the history (default 500)
# for other see the man page bash(1)
HISTSIZE=10000
HISTFILESIZE=20000
#HISTFILE=~/.history
#HISTTIMEFORMAT="[%F %T] "
#HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Color escape sequence
C_RESET='\033[0m'
C_BLACK='\033[0;30m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'
C_MAGENTA='\033[0;35m'
C_CYAN='\033[0;36m'
C_WHITE='\033[0;37m'

C_BOLD_RESET='\033[1m'
C_BOLD_BLACK='\033[1;30m'
C_BOLD_RED='\033[1;31m'
C_BOLD_GREEN='\033[1;32m'
C_BOLD_YELLOW='\033[1;33m'
C_BOLD_BLUE='\033[1;34m'
C_BOLD_MAGENTA='\033[1;35m'
C_BOLD_CYAN='\033[1;36m'
C_BOLD_WHITE='\033[1;37m'

# Set Colorful PS1
# Attribute codes: 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
# Text color codes: 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
# Define an alias for the color - remember to escape with \[ at begin and \] at the end or
# with the equivalent octal code \001 and \002, the octal code \033 can be substituted by '\e'.
# If you don't escape the prompt break the newline like inserting a carriage return
PS1="\[${C_BOLD_GREEN}\]\u\[${C_BOLD_WHITE}\]@\[${C_BOLD_RED}\]\h\[${C_BOLD_WHITE}\]:\[${C_BOLD_CYAN}\]\W\[${C_BOLD_YELLOW}\] \\$\[${C_RESET}\] "

# Extend PS1 with colorful/dynamic git branch
# Escape the start and the end
# N.B if I use the \[ with printf doesn't work, but I don't know why
es="\001"
ee="\002"
C_UL_RED='\033[4;31m'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
   test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
   alias ls='ls --color=auto'
   alias ll='ls -lah'
   alias dir='dir --color=auto'
   alias vdir='vdir --color=auto'
   alias grep='grep --color=auto'
   alias fgrep='fgrep --color=auto'
   alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias ossh='ssh -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no"'
alias oscp='scp -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no"'
