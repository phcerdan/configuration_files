#!/bin/bash
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo "Trying to setup following simlinks: .vimrc ; .tmux.conf ; .vimperatorrc ; .tmuxifier/layouts; .vim/UltiSnips"
cd $HOME
ln -s $SCRIPT_DIR/dot_files/.vimrc .
ln -s $SCRIPT_DIR/dot_files/.tmux.conf .
ln -s $SCRIPT_DIR/dot_files/.vimperatorrc .
cd $HOME/.tmuxifier
ln -s $SCRIPT_DIR/tmuxifier/layouts .
cd $HOME/.vim
ln -s $SCRIPT_DIR/vim/UltiSnips .


