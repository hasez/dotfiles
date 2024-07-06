#!/usr/bin/env zsh
#shellcheck shell=bash

export LANG=en_US.UTF-8
export LESS='-R'
export LESSCHARSET=utf-8
export LESSHISTFILE=-
export TERM=xterm-256color
export SHELL_SESSIONS_DISABLE=1
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
export FZF_DEFAULT_OPTS='--no-sort --no-mouse --reverse --no-separator --ansi'
export FPATH=$ZDOTDIR/functions:$FPATH
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_COMPLETION_IGNORE=' *(git clone|git remote|ssh|scp) *'
export PMY_TRIGGER_KEY=^I
export AWS_PAGER=""

if [ -d "$HOME/Library/Mobile Documents/com~apple~CloudDocs" ]; then
    export ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
fi

# Homebrew
if [ -d /opt/homebrew ]; then
    export HOMEBREW_PREFIX=/opt/homebrew
    export HOMEBREW_CELLAR=$HOMEBREW_PREFIX/Cellar
    export HOMEBREW_REPOSITORY=$HOMEBREW_PREFIX
    # homebrew path add to PATH
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
