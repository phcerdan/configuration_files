#!/bin/zsh
# Clone zgen if you haven't already
if [ ! -f ~/zgen/zgen.zsh ]; then
    pushd ~
    git clone https://github.com/tarjoilija/zgen.git
    popd
fi
source "${HOME}/zgen/zgen.zsh"

if ! zgen saved; then
    echo "Creating a zgen save"
    # Most fav plugins ever.
    zgen load jimmijj/zsh-syntax-highlighting
    zgen load zsh-users/zsh-history-substring-search
    # autosuggestions should be loaded last
    zgen load tarruda/zsh-autosuggestions
    # colorize list of folder with git information.
    zgen load rimraf/k
    # Notify (require libnotify-bin)
    zgen load marzocchi/zsh-notify
    # Pure. Minimalistic prompt.
    # zgen load mafredri/zsh-async
    # zgen load sindresorhus/pure
    # git autocompletion
    zgen load bobthecow/git-flow-completion
    zgen load chrissicool/zsh-256color
    zgen load zsh-users/zsh-completions src

    # You don't require zgen oh-my-zsh for basic plugins.
    zgen oh-my-zsh
    zgen oh-my-zsh command-not-found
    zgen oh-my-zsh z
    zgen oh-my-zsh git
    # INSTALL FONTS: git clone https://github.com/powerline/fonts; cd fonts;./install.sh
    # https://powerline.readthedocs.org/en/latest/installation/linux.html#font-installation
    # fc-cache -vf ~/.fonts/
    # AND create a new profile in terminal, select powerline font (Liberation)
    zgen oh-my-zsh themes/fishy
    # zgen load caiogondim/bullet-train-oh-my-zsh-theme bullet-train
    zgen save
fi
# Tmux
# Automatic rename at "cd /to/folder/" when tmux is set to screen-256color. Harmless workaround here in zsh.:
DISABLE_AUTO_TITLE=true

# FROM BASHRC
export EDITOR='nvim'
export PATH="$HOME/.tmuxifier/bin:$PATH"
alias mux='tmuxifier'
alias vim='nvim'
alias sdevd='source /home/phc/bin/devtoolset-debug.sh'
alias sdevr='source /home/phc/bin/devtoolset-release.sh'

alias cmakeEclipseSource='cmake -G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_ECLIPSE_GENERATE_SOURCE_PROJECT=TRUE'
alias ccmakeEclipseSource='ccmake -G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_ECLIPSE_GENERATE_SOURCE_PROJECT=TRUE'
alias cmakeEclipse='cmake -G"Eclipse CDT4 - Unix Makefiles"'
alias ccmakeEclipse='ccmake -G"Eclipse CDT4 - Unix Makefiles"'
alias cmakeEclipseC11='cmake -G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_CXX_COMPILER_ARG1=-std=c++11'
alias ccmakeEclipseC11='ccmake -G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_CXX_COMPILER_ARG1=-std=c++11'
# vim: set filetype=sh:
