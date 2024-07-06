#!/usr/bin/env zsh
#shellcheck shell=bash

# if [ -f /opt/homebrew/bin/brew ]; then
#     eval "$(/opt/homebrew/bin/brew shellenv)"
# fi

echo "call my zshenv"

export ZDOTDIR=$HOME/.zsh
source "$ZDOTDIR/.zshenv"
