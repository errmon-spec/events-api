#!/bin/bash

# git prompt
# shellcheck disable=SC1091
export GIT_PS1_SHOWUPSTREAM="auto"
source /usr/lib/git-core/git-sh-prompt
# shellcheck disable=SC2154
PS1='${debian_chroot:+($debian_chroot)}\u@\h:$(__git_ps1 "[%s]:")\w\$ '

# history
export HISTCONTROL="erasedups:ignoreboth:ignorespace"
export HISTFILE="/root/history.d/.bash_history"
export HISTFILESIZE=-1
export HISTSIZE=-1
export PROMPT_COMMAND="history -a"

# editor
export EDITOR=vim

# history helpers
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

# bash completion
bind "set bell-style visible"
bind "set colored-completion-prefix on"
bind "set colored-stats on"
bind "set completion-ignore-case on"
bind "set completion-map-case on"
bind "set show-all-if-ambiguous on"

# useful aliases
alias ..="cd .."
alias grep="grep --color=auto"
alias home="cd ~"
alias la="ls -la"
alias ls="ls --color=auto --group-directories-first --human-readable --literal"
alias mkdir="mkdir --parents --verbose"
alias vi="vim"

shopt -s autocd \
  cdspell \
  cmdhist \
  dirspell \
  histappend \
  histverify \
  no_empty_cmd_completion \
  xpg_echo
