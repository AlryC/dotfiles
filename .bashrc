#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Vim motions
set -o vi

alias ls='ls --color=auto'
alias la='ls -a --color=auto'
alias grep='grep --color=auto'

alias ff='fastfetch'
alias ffd='fastfetch -c ~/.config/fastfetch/default.jsonc'

alias code='code-oss'

alias cfb='vim ~/.bashrc'
alias cfd='sudo vim /usr/local/bin/startdwm.sh'
alias cff='vim ~/.config/fastfetch/config.jsonc'
alias cfk='vim ~/.config/kitty/kitty.conf'
alias cfv='vim ~/.vimrc'

alias xi='sudo xbps-install'

#PS1='\[\e[0;31m\] [ \[\e[0;33m\] \u \[\e[0;32m\] @ \[\e[0;36m\] \h \[\e[0;34m\] \W \[\e[0;35m\] ] \[\e[0;30m\] \$ \[\e[0;m\]'
PS1='\[\e[0;35m\][\[\e[0;33m\]\u\[\e[0;35m\]@\[\e[0;33m\]\h\[\e[0;33m\] \W\[\e[0;35m\]]\[\e[0;37m\]\$ \[\e[0;m\]'
