#!/bin/bash

set -e
set -u

: docker container run --rm -it -v "$PWD:$PWD":ro -w "$PWD" alpine:3 sh -c '
    apk --no-cache add bash curl git vim
    ./install.sh
    ls -Al ~
'

ROOT=${ROOT:-~/src/github.com/hasez/dotfiles}

if [ ! -d "$ROOT" ]; then
    git clone https://github.com/hasez/dotfiles.git "$ROOT"
fi

mkdir -p ~/.config
mkdir -p ~/.zsh

function create_link {
    local _src
    local _dest
    _src=$1
    _dest=${2:-$1}

    if [ -e "$HOME/$_dest" ] && [ ! -s "$HOME/$_dest" ]; then
        mkdir -p "$HOME/.dotfiles-backup"
        mv "$HOME/$_dest" "$HOME/.dotfiles-backup/$_dest"
    fi

    rm -f "$HOME/$_dest"
    ln -fsv "$ROOT/src/$_src" "$HOME/$_dest"
}

create_link .config/zabrze
create_link .zsh/functions
create_link .zsh/.zshenv
create_link .zsh/.zshrc
create_link .zsh/.zshrc.local
create_link bin
create_link .bash_profile
create_link .bashrc
create_link .editorconfig4 .editorconfig
create_link .gitconfig
create_link .gitconfig.local
create_link .tmux.conf
create_link .vimrc
create_link .zshenv

# Install Tmux Plugin Manager
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm
fi

# Install vim-plug
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -fsSL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o ~/.vim/autoload/plug.vim --create-dirs
    sed -e '/colorscheme/d' ~/.vimrc >/tmp/.vimrc_deleteme
    vim -u /tmp/.vimrc_deleteme +PlugInstall +qall </dev/null >/dev/null 2>&1
    rm /tmp/.vimrc_deleteme
fi

# Setup git config user.email and user.name
GIT_CONFIG_LOCAL=~/.gitconfig.local
if [ ! -e $GIT_CONFIG_LOCAL ]; then
    echo -n "git config user.email?> "
    read -r GIT_AUTHOR_EMAIL

    echo -n "git config user.name?> "
    read -r GIT_AUTHOR_NAME

    cat << EOF > $GIT_CONFIG_LOCAL
[user]
    name = $GIT_AUTHOR_NAME
    email = $GIT_AUTHOR_EMAIL
EOF
fi

# Install Homebrew
if [ ! -d /opt/homebrew ]; then
    mkdir -p /opt/homebrew
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash -s -- --prefix=/opt/homebrew
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # Install Homebrew packages
    brew bundle --file="$ROOT/src/Brewfile"
    # add /opt/homebrew/bin to /etc/paths at head if not exists
    if ! grep -qxF '/opt/homebrew/bin' /etc/paths; then
        sudo sed -i '' '1i\ /opt/homebrew/bin' /etc/paths
    fi
fi