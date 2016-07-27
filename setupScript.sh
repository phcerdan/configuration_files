#!/bin/bash
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo "Trying to setup following simlinks: .vimrc ; .tmux.conf ; .zshrc, and .aliases; .vimperatorrc ; .tmuxifier/layouts; .vim/UltiSnips ; .eclimrc ; ycm_extra_conf.py ; colorgcc ; .emacs.d/init.el"
cd $HOME
ln -s $SCRIPT_DIR/dot_files/.vimrc .
ln -s $SCRIPT_DIR/dot_files/.tmux.conf .
ln -s $SCRIPT_DIR/dot_files/.zshrc .
ln -s $SCRIPT_DIR/dot_files/.aliases .
ln -s $SCRIPT_DIR/dot_files/.vimperatorrc .
ln -s $SCRIPT_DIR/dot_files/.ycm_extra_conf.py .
ln -s $SCRIPT_DIR/dot_files/.colorgcc .
ln -s $SCRIPT_DIR/eclipse/.eclimrc .
cd $HOME/.tmuxifier
ln -s $SCRIPT_DIR/tmuxifier/layouts .
cd $HOME/.vim
ln -s $SCRIPT_DIR/vim/UltiSnips .
mkdir $HOME/.emacs.d ; cd $HOME/.emacs.d
ln -s $SCRIPT_DIR/emacs.d/init.el .

echo "Cloning (git) Plugin managers in .vim (Vundle) and .tmux (tpm)"
# zsh manager zgen, should be handled in .zshrc
# vim manager Plug, should be handled in .vimrc
# tmux manager:
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "Success! (Eclim require extra steps.)"

