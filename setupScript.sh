#!/bin/bash
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo "Trying to setup following simlinks: .vimrc ; .tmux.conf ; .zshrc, and .aliases; .vimperatorrc ; .tmuxifier/layouts; .vim/UltiSnips ; .eclimrc ; ycm_extra_conf.py ; colorgcc ; .spacemacs ; .gitconfig ; .git_template"
cd $HOME
ln -s $SCRIPT_DIR/dot_files/.vimrc .
ln -s $SCRIPT_DIR/dot_files/.tmux.conf .
ln -s $SCRIPT_DIR/dot_files/.tmux.lightline .
ln -s $SCRIPT_DIR/dot_files/.zshrc .
ln -s $SCRIPT_DIR/dot_files/.aliases .
ln -s $SCRIPT_DIR/dot_files/.vimperatorrc .
ln -s $SCRIPT_DIR/dot_files/.ycm_extra_conf.py .
ln -s $SCRIPT_DIR/dot_files/.colorgcc .
ln -s $SCRIPT_DIR/dot_files/.latexmkrc .
ln -s $SCRIPT_DIR/eclipse/.eclimrc .
ln -s $SCRIPT_DIR/emacs/.spacemacs .
ln -s $SCRIPT_DIR/git_files/.gitconfig .
ln -s $SCRIPT_DIR/git_files/.git_template .
cd $HOME/.tmuxifier
ln -s $SCRIPT_DIR/tmuxifier/layouts .
cd $HOME/.vim
ln -s $SCRIPT_DIR/vim/UltiSnips .

echo "Cloning (git) Plugin managers in .vim (Vundle) and .tmux (tpm)"
# zsh manager zgen, should be handled in .zshrc
# vim manager Plug, should be handled in .vimrc
# tmux manager:
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "Setting base16-shell scripts into ~/.config/base16-shell"
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
echo "Success! (Eclim require extra steps.)"
