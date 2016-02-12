#!/bin/zsh
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
# Clone zgen if you haven't already
if [ ! -f ~/zgen/zgen.zsh ]; then
    pushd ~
    git clone https://github.com/tarjoilija/zgen.git
    popd
fi
source "${HOME}/zgen/zgen.zsh"

if ! zgen saved; then
    echo "Creating a zgen save"
    # autosuggestions should be loaded last
    zgen load tarruda/zsh-autosuggestions
    # Add history-substring-search-* widgets to list of widgets that clear the autosuggestion
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(history-substring-search-up history-substring-search-down)

    # Remove *-line-or-history widgets from list of widgets that clear the autosuggestion to avoid conflict with history-substring-search-* widgets
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS=("${(@)ZSH_AUTOSUGGEST_CLEAR_WIDGETS:#(up|down)-line-or-history}")
    # Most fav plugins ever.
    zgen load jimmijj/zsh-syntax-highlighting
    zgen load zsh-users/zsh-history-substring-search
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
    zgen load rupa/z

    # You don't require zgen oh-my-zsh for basic plugins.
    zgen oh-my-zsh
    zgen oh-my-zsh command-not-found
    zgen oh-my-zsh git
    # ESC ESC pre-pend sudo in current line.
    zgen oh-my-zsh sudo
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

# LOAD general .aliases.
source $HOME/.aliases

if hash nvim 2>/dev/null; then
    export EDITOR='nvim'
    # alias vim='nvim'
else
    export EDITOR='vim'
fi
export PATH="$HOME/.tmuxifier/bin:$PATH"

######## CCACHE, colorgcc ######
# USE ccache for gcc compilers.
# Check that you have ~/.colorgcc pointing to ccache compilers
if ( hash ccache 2>/dev/null ) && (hash colorgcc 2>/dev/null); then
    export ccache_loaded="loaded"
    export PATH="/usr/lib/colorgcc/bin:$PATH"
    export CCACHE_PATH="/usr/bin"
fi

###### FUNCTIONS ######
# make a backup of a file
# https://github.com/grml/grml-etc-core/blob/master/etc/zsh/zshrc
bk() {
    cp -a "$1" "${1}_$(date --iso-8601=seconds)"
}

# print a separator banner, as wide as the terminal
function sep {
    print ${(l:COLUMNS::=:)}
}

# launch an app
function launch {
	type $1 >/dev/null || { print "$1 not found" && return 1 }
	$@ &>/dev/null &|
}
alias launch="launch " # expand aliases
# vim: set filetype=sh:
