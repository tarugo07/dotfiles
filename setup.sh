#!/bin/bash

THIS=$(cd $(dirname $0);pwd)
DOTFILES=(.zprofile .zshenv .zshrc .zshrc.antigen .zshrc.alias .gitconfig .gitignore .tmux.conf .latexmkrc)

for file in ${DOTFILES[@]}
do
    ln -s $THIS/$file $HOME/$file
done

mkdir -p $HOME/.zsh/completions
mkdir -p $HOME/bin
