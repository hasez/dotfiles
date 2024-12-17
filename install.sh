#!/usr/bin/env sh

set -e  # エラーが発生した場合にスクリプトを停止
set -u  # 未定義の変数を使用した場合にエラー

# Alpine コンテナ内で必要なツールをインストール
: docker container run --rm -it -v "$PWD:$PWD":ro -w "$PWD" alpine:3 sh -c '
    apk --no-cache add bash curl git vim
    ./install.sh
    ls -Al ~
'

# dotfiles リポジトリのクローン設定
ROOT=${ROOT:-~/src/github.com/hasez/dotfiles}
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"

if [ ! -d "$ROOT" ]; then
    echo "Cloning dotfiles repository into $ROOT"
    git clone https://github.com/hasez/dotfiles.git "$ROOT"
fi

# 必要なディレクトリを作成
mkdir -p ~/.config ~/.zsh

# シンボリックリンク作成関数
create_link() {
    _src=$1
    _dest=${2:-$1}

    # 既存ファイルがあればバックアップ
    if [ -e "$HOME/$_dest" ] && [ ! -s "$HOME/$_dest" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "Backing up existing file: $HOME/$_dest to $BACKUP_DIR"
        mv "$HOME/$_dest" "$BACKUP_DIR/$_dest"
    fi

    # シンボリックリンク作成
    rm -f "$HOME/$_dest"
    ln -fsv "$ROOT/src/$_src" "$HOME/$_dest"
}

# 設定ファイルのリンク作成
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

# Tmux Plugin Manager のインストール
if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "Installing Tmux Plugin Manager (TPM)"
    git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm
fi

# vim-plug のインストール
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    echo "Installing vim-plug"
    curl -fsSL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o ~/.vim/autoload/plug.vim --create-dirs
    sed -e '/colorscheme/d' ~/.vimrc >/tmp/.vimrc_deleteme
    vim -u /tmp/.vimrc_deleteme +PlugInstall +qall </dev/null >/dev/null 2>&1
    rm /tmp/.vimrc_deleteme
fi

# Git ユーザ設定の確認・作成
GIT_CONFIG_LOCAL=~/.gitconfig.local
if [ ! -e "$GIT_CONFIG_LOCAL" ]; then
    echo "Setting up Git user configuration"

    while [ -z "${GIT_AUTHOR_EMAIL:-}" ]; do
        printf "git config user.email?> "
        read -r GIT_AUTHOR_EMAIL || exit 1
    done

    while [ -z "${GIT_AUTHOR_NAME:-}" ]; do
        printf "git config user.name?> "
        read -r GIT_AUTHOR_NAME || exit 1
    done

    cat << EOF > "$GIT_CONFIG_LOCAL"
[user]
    name = $GIT_AUTHOR_NAME
    email = $GIT_AUTHOR_EMAIL
EOF
    echo "Git user configuration saved to $GIT_CONFIG_LOCAL"
fi

echo "Setup completed successfully."
