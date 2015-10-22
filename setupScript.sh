#!/bin/bash
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo "Trying to setup following simlinks: .vimrc ; .tmux.conf ; .vimperatorrc ; .tmuxifier/layouts; .vim/UltiSnips ; .eclimrc"
cd $HOME
ln -s $SCRIPT_DIR/dot_files/.vimrc .
ln -s $SCRIPT_DIR/dot_files/.tmux.conf .
ln -s $SCRIPT_DIR/dot_files/.vimperatorrc .
ln -s $SCRIPT_DIR/eclipse/.eclimrc .
cd $HOME/.tmuxifier
ln -s $SCRIPT_DIR/tmuxifier/layouts .
cd $HOME/.vim
ln -s $SCRIPT_DIR/vim/UltiSnips .

echo "Cloning (git) Plugin managers in .vim (Vundle) and .tmux (tpm)"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "Success: Eclim, YouCompleteMe and vim-R plugins require extra steps."

