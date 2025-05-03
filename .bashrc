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
alias cfd='vim ~/suckless/assets/scripts/startdwm.sh'
alias cffa='vim ~/.config/fastfetch/config.jsonc'
alias cff='vim ~/.config/fish/config.fish'
alias cfk='vim ~/.config/kitty/kitty.conf'
alias cfv='vim ~/.vimrc'

alias xu='sudo xbps-install'
alias xq='xbps-query'
alias xrr='sudo xbps-remove'

#PS1='\[\e[0;31m\] [ \[\e[0;33m\] \u \[\e[0;32m\] @ \[\e[0;36m\] \h \[\e[0;34m\] \W \[\e[0;35m\] ] \[\e[0;30m\] \$ \[\e[0;m\]'
PS1='\[\e[0;35m\][\[\e[0;33m\]\u\[\e[0;35m\]@\[\e[0;33m\]\h\[\e[0;33m\] \W\[\e[0;35m\]]\[\e[0;37m\]\$ \[\e[0;m\]'

. "$HOME/.local/bin/env"
