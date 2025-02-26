#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias la='ls -a --color=auto'
alias grep='grep --color=auto'

alias ff='fastfetch'
alias ffd='fastfetch -c ~/.config/fastfetch/default.jsonc'

alias cfb='vim ~/.bashrc'
alias cff='vim ~/.config/fastfetch/config.jsonc'
alias cfk='vim ~/.config/kitty/kitty.conf'
alias cfo='vim ~/.config/openbox/lxde-rc.xml'
alias cfv='vim ~/.vimrc'

#PS1='\[\e[0;31m\] [ \[\e[0;33m\] \u \[\e[0;32m\] @ \[\e[0;36m\] \h \[\e[0;34m\] \W \[\e[0;35m\] ] \[\e[0;30m\] \$ \[\e[0;m\]'
PS1='\[\e[0;31m\][\[\e[0;33m\]\u\[\e[0;32m\]@\[\e[0;36m\]\h\[\e[0;34m\] \W\[\e[0;35m\]]\[\e[0;37m\]\$ \[\e[0;m\]'
