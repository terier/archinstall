# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -l --group-directories-first'
alias l='ls -1 --group-directories-first'
alias ΩΩΩ='pacaur -Syu'

export PS1='\[\e[0;35m\]╭─┤\[\e[0;33m\] $? \[\e[0;30m\e[46m\] \w ░▒▓\[\e[0m\]\n\[\e[0;35m\]╰╸\[\e[0m\]'
