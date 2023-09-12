#!/bin/bash

THIS=$(cd $(dirname $0);pwd)
DOTFILES=(.zshenv .zshrc .zshrc.antigen .zshrc.alias .gitconfig .gitignore .tmux.conf)

for file in ${DOTFILES[@]}
do
    ln -s $THIS/$file $HOME/$file
done

mkdir -p $HOME/.zsh/completions
mkdir -p $HOME/bin
