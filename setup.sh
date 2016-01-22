#!/bin/bash

THIS=$(cd $(dirname $0);pwd)
DOTFILES=(.zshrc .gitconfig .gitignore .tmux.conf)

for file in ${DOTFILES[@]}
do
    ln -s $THIS/$file $HOME/$file
done
