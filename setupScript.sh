#!/bin/bash
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo "Trying to setup following simlinks: .vimrc ; .tmux.conf .tmux_utils ; .zshrc, .aliases, .functions, .devenviron; .vimperatorrc ; .tmuxifier/layouts; .vim/UltiSnips ; .eclimrc ; ycm_extra_conf.py ; colorgcc ; .spacemacs ; .gitconfig ; .git_template ; .fzf.conf ; .config/cower/config ; .config/termite/config ; .config/gtk-3.0/gtk.css ; .config/pycodestyle "
cd $HOME
ln -s $SCRIPT_DIR/dot_files/.vimrc .
ln -s $SCRIPT_DIR/dot_files/.tmux.conf .
ln -s $SCRIPT_DIR/dot_files/.tmux_simple.airline
ln -s $SCRIPT_DIR/dot_files/.tmux_mem-cpu-load.airline .
ln -s .tmux_mem-cpu-load.airline .tmux.airline
ln -s $SCRIPT_DIR/dot_files/.tmux_utils .
ln -s $SCRIPT_DIR/dot_files/.zshrc .
ln -s $SCRIPT_DIR/dot_files/.fzf.conf .
ln -s $SCRIPT_DIR/dot_files/.aliases .
ln -s $SCRIPT_DIR/dot_files/.functions .
ln -s $SCRIPT_DIR/dot_files/.devenviron .
ln -s $SCRIPT_DIR/dot_files/.vimperatorrc .
ln -s $SCRIPT_DIR/dot_files/.ycm_extra_conf.py .
ln -s $SCRIPT_DIR/dot_files/.colorgcc .
ln -s $SCRIPT_DIR/dot_files/.colorgcc .colorgccrc
ln -s $SCRIPT_DIR/dot_files/.latexmkrc .
ln -s $SCRIPT_DIR/dot_files/.Xdefaults .
ln -s $SCRIPT_DIR/dot_files/.Xresources .
ln -s $SCRIPT_DIR/dot_files/.Xresources.d .
ln -s $SCRIPT_DIR/eclipse/.eclimrc .
ln -s $SCRIPT_DIR/emacs/.spacemacs .
ln -s $SCRIPT_DIR/git_files/.gitconfig .
ln -s $SCRIPT_DIR/git_files/.git_template .
ln -s $SCRIPT_DIR/git_files/.gitignore .
ln -s $SCRIPT_DIR/gdb/minimal_gdbinit ./.gdbinit
mkdir -p $HOME/.tmuxifier ; cd $_
ln -s $SCRIPT_DIR/tmuxifier/layouts .
mkdir -p $HOME/.vim ; cd $_
ln -s $SCRIPT_DIR/vim/UltiSnips .
ln -s $SCRIPT_DIR/vim/ftplugin .
mkdir -p $HOME/.config/cower ; cd $_
ln -s $SCRIPT_DIR/dot_files/config/cower/config .
mkdir -p $HOME/.config/termite ; cd $_
ln -s $SCRIPT_DIR/dot_files/config/termite/config .
mkdir -p $HOME/.config/gtk-3.0 ; cd $_
ln -s $SCRIPT_DIR/dot_files/config/gtk-3.0/gtk.css .
mkdir -p $HOME/.config/nvim ; cd $_
ln -s $SCRIPT_DIR/dot_files/config/nvim/coc-settings.json .
cd $HOME/.config
ln -s $SCRIPT_DIR/dot_files/config/pycodestyle .
ln -s $SCRIPT_DIR/dot_files/config/flake8 .

echo "Cloning (git) Plugin managers in .vim (Vundle) and .tmux (tpm)"
# zsh manager zgen, should be handled in .zshrc
# vim manager Plug, should be handled in .vimrc
# tmux manager:
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "Setting base16-shell scripts into ~/.config/base16-shell"
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
echo "Success! (Eclim require extra steps.)"
