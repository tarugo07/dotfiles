#!/bin/bash

DOTFILES_PATH=$(cd $(dirname $0);pwd)
DOTFILES_FILES=(.zshrc .gitconfig .gitignore .tmux.conf)

for file in ${DOTFILES_FILES[@]}
do
    ln -s $DOTFILES_PATH/$file $HOME/$file
done
