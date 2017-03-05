#!/bin/bash

THIS=$(cd $(dirname $0);pwd)
DOTFILES=(.zshenv .zshrc .zshrc.antigen .gitconfig .gitignore .tmux.conf)

for file in ${DOTFILES[@]}
do
    ln -s $THIS/$file $HOME/$file
done
