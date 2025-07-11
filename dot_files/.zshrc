#!/bin/zsh

# Disable warning in mac and oh-my-zsh autocompletion plugin
# platform=$(uname -s)
# if [[ "${platform}" == "Darwin" ]]; then
#     ZSH_DISABLE_COMPFIX=true
# fi
# Add JUPUTERLAB_DIR to enable extensions in --user:
export TOTALSEG_NO_STATISTICS=1
# Following https://wiki.archlinux.org/index.php/Jupyter
export JUPYTERLAB_DIR=$HOME/.local/share/jupyter/lab
# Add python scripts of clang to path
export PATH="/usr/share/clang:$PATH"
# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"
# Require: mkdir ~/.npm-global ; npm config set prefix '~/.npm-global'
export PATH="$HOME/.npm-global/bin:$PATH"
if type ruby > /dev/null 2>&1; then
    export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
fi
# Python pip --user (at the end)
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
# Python virtualenvwrapper
export WORKON_HOME=~/.virtualenvs
if false; then
    if [ -f /usr/bin/virtualenvwrapper.sh ]; then
	source /usr/bin/virtualenvwrapper.sh
    elif [ -f /usr/share/virtualenvwrapper/virtualenvwrapper.sh ]; then
	source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
    fi
    # git clone https://github.com/fbudin69500/terminal.workspace.git $HOME/.terminal.workspace
    if [ -f $HOME/.terminal.workspace/workspace.config ]; then
	source ~/.terminal.workspace/workspace.config
    fi
fi

# To solve bug in nvim about <c-h> https://github.com/neovim/neovim/issues/2048
# export TERMINFO="$HOME/.terminfo"

####### POWERLEVEL9K CONFIGURATION ########### {{{
# P9K_IGNORE_VAR_WARNING=true
# POWERLEVEL9K_MODE='awesome-patched'
POWERLEVEL9K_MODE='nerdfont-complete'
# POWERLEVEL9K_MODE='awesome-fontconfig'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv context dir_writable dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(time command_execution_time)
# You can also use different prompts in different environments, e.g. for TMUX, you might use
# if [[ "${TERM}" =~ "tmux" || "${TERM}" =~ "screen" ]]; then
#     POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs command_execution_time)
# else
#     POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs command_execution_time time)
# fi

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
# POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
# POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=""
# POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='\u256D\U2500'     # ╭─
# POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX='\u2570\U2500 '   # ╰─
# To apply color: preppend: \033[32m , 32 is green, 37 is white...
# POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='\u250F\U2501'     # ┏━
# POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX='\u2517\U2501 '   # ┗━

### segments ###
# context:
DEFAULT_USER="$USER" #Avoid showing context when no need (SSH, other user)
# dir:
# truncate: ~/repository_local/build/hola/ -> ~/r/b/hola
# POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
# POWERLEVEL9K_SHORTEN_DELIMITER=""
# POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
# remove symbols
POWERLEVEL9K_HOME_ICON=''
POWERLEVEL9K_HOME_SUB_ICON=''
POWERLEVEL9K_FOLDER_ICON=''

# vcs
POWERLEVEL9K_HIDE_BRANCH_ICON=true
POWERLEVEL9K_SHOW_CHANGESET=true
POWERLEVEL9K_CHANGESET_HASH_LENGTH=8
# # Default is slow... too many git commands. There is a PR with async vcs status, might be worth to restore when merged.
# POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind git-stash git-remotebranch git-tagname)
# POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes) # FAST VERSION
POWERLEVEL9K_VCS_GIT_ICON=''
POWERLEVEL9K_VCS_GIT_GITHUB_ICON=''
POWERLEVEL9K_VCS_GIT_GITLAB_ICON=''
POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON=''
#### END POWERLEVEL9K CONFIGURATION #### }}}

# Add zsh completion folder from arch
arch_completions="/usr/share/zsh/site-functions"
if [ ! -f $arch_completions ]; then
    fpath=($arch_completions $fpath)
fi

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
    # zgen load jimmijj/zsh-syntax-highlighting
    # Replace by fast-syntax-highlighting, the former is buggy with zsh-vi-mode
    zgen load zdharma-continuum/fast-syntax-highlighting

    zgen load zsh-users/zsh-history-substring-search
    # colorize list of folder with git information.
    zgen load rimraf/k
    # Notify (require libnotify-bin). And wmctrl
    zgen load marzocchi/zsh-notify
    # Pure. Minimalistic prompt.
    # zgen load mafredri/zsh-async
    # zgen load sindresorhus/pure
    # git autocompletion
    zgen load bobthecow/git-flow-completion
    zgen load chrissicool/zsh-256color
    zgen load zsh-users/zsh-completions src
    # Try good vim mode
    zgen load jeffreytse/zsh-vi-mode

    # You don't require zgen oh-my-zsh for basic plugins.
    zgen oh-my-zsh

    zgen oh-my-zsh plugins/command-not-found
    zgen oh-my-zsh plugins/git
    # ESC ESC pre-pend sudo in current line.
    # zgen oh-my-zsh plugins/sudo
    # INSTALL FONTS: git clone https://github.com/powerline/fonts; cd fonts;./install.sh
    # https://powerline.readthedocs.org/en/latest/installation/linux.html#font-installation
    # fc-cache -vf ~/.fonts/
    # AND create a new profile in terminal, select powerline font (Liberation)

    # Theme (fishy from oh-my-zsh not working in ARCH)
    # zgen oh-my-zsh themes/arrow
    # zgen load arialdomartini/oh-my-git
    # zgen load arialdomartini/oh-my-git-themes oppa-lana-style
    # zgen load phcerdan/fishy-gentoo fishy-gentoo
    ## pure
    # zgen load mafredri/zsh-async
    # zgen load sindresorhus/pure
    # zgen load bhilburn/powerlevel9k powerlevel9k
    zgen load romkatv/powerlevel10k powerlevel10k
    # zgen load denysdovhan/spaceship-prompt spaceship

    # autosuggestions should be loaded last (annoying!)
    zgen load zsh-users/zsh-autosuggestions
    # zgen load tarruda/zsh-autosuggestions
    # Add history-substring-search-* widgets to list of widgets that clear the autosuggestion
    # ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(history-substring-search-up history-substring-search-down)

    # Remove *-line-or-history widgets from list of widgets that clear the autosuggestion to avoid conflict with history-substring-search-* widgets
    # ZSH_AUTOSUGGEST_CLEAR_WIDGETS=("${(@)ZSH_AUTOSUGGEST_CLEAR_WIDGETS:#(up|down)-line-or-history}")
    zgen save
fi
# # Reload the zsh-completions
autoload -U compinit && compinit

# Tmux
# Automatic rename at "cd /to/folder/" when tmux is set to screen-256color. Harmless workaround here in zsh.:
DISABLE_AUTO_TITLE=true

# LOAD handy functions
source $HOME/.functions
# LOAD general .aliases.
source $HOME/.aliases
# Set some handy CXX_FLAGS
source $HOME/.devenviron
# Enable bash (tmux) functions
source $HOME/.tmux_utils
# Enable bash (tmux) functions
source $HOME/.tmux_utils
source $HOME/.secrets 2> /dev/null
# base16stuff (only arch?)
# BASE16_SHELL=$HOME/.config/base16-shell/
# [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
# base16_monokai

# Base16 Shell
# BASE16_SHELL="$HOME/.config/base16-shell/"
# [ -n "$PS1" ] && \
#     [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
#     eval "$("$BASE16_SHELL/profile_helper.sh")"

export EDITOR='vim'
if type nvim > /dev/null 2>&1; then
    export EDITOR='nvim'
fi
export PATH="$HOME/.tmuxifier/bin:$PATH"

# Workaround for tmp loaded only at the end of tmux.conf
export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins"
######## Options ###### from: https://github.com/wincent/wincent/blob/master/roles/dotfiles/files/.zshrc
# setopt autocd               # .. is shortcut for cd .. (etc)
setopt autoparamslash       # tab completing directory appends a slash
setopt autopushd            # cd automatically pushes old dir onto dir stack
# setopt clobber              # allow clobbering with >, no need to use >!
# setopt correct              # command auto-correction
# setopt correctall           # argument auto-correction
setopt nocorrectall         # disable correction
setopt noflowcontrol        # disable start (C-s) and stop (C-q) characters
setopt nonomatch            # unmatched patterns are left unchanged
setopt histignorealldups    # filter duplicates from history
setopt histignorespace      # don't record commands starting with a space
setopt histverify           # confirm history expansion (!$, !!, !foo)
setopt ignoreeof            # prevent accidental C-d from exiting shell
setopt interactivecomments  # allow comments, even in interactive shells
# setopt printexitvalue       # for non-zero exit status
setopt pushdignoredups      # don't push multiple copies of same dir onto stack
setopt pushdsilent          # don't print dir stack after pushing/popping
setopt sharehistory         # share history across shells

# #### bash: `complete` compatibility ####
# autoload +X bashcompinit && bashcompinit
#
# # clang_complete
# clang_completion="/usr/share/clang/bash-autocomplete.sh"
# if [ -f $clang_completion ]; then
#     source $clang_completion
# fi
# export hola=$(echo "hola" | sed "s/hola/adios/g")

#### color prompt (ugly as hell)####
# autoload -Uz promptinit
# promptinit

######## CCACHE, colorgcc ######
# USE ccache for gcc compilers.
# Check that you have ~/.colorgcc pointing to ccache compilers
# Based on: https://stackoverflow.com/questions/1995415/g-colorgcc-and-ccache/5854549
if ( hash ccache 2>/dev/null ) && (hash colorgcc 2>/dev/null); then
    export ccache_loaded="loaded"
    export PATH="/usr/lib/colorgcc/bin:$PATH"
    export CCACHE_PATH="/usr/bin"
    # Disable it for a shell with:
    # export CCACHE_DISABLE=1
fi

###### FUNCTIONS ######
# make a backup of a file
# https://github.com/grml/grml-etc-core/blob/master/etc/zsh/zshrc
bk() {
    cp -a "$1" "${1}_$(date --iso-8601=seconds)"
}
disable_ow_color() {
    export LS_COLORS="$LS_COLORS:ow="
    # Removes all colors for zsh-autocomplete
    zstyle ':completion:*' list-colors
    # zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
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
#
if [ -f /usr/share/fzf/key-bindings.zsh ]; then
    zvm_after_init_commands+=('[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh && [ -f ~/.fzf.conf ] && source ~/.fzf.conf')
elif [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    zvm_after_init_commands+=('[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh && [ -f ~/.fzf.conf ] && source ~/.fzf.conf')
fi

# asdf (paru -S asdf-vm)
# . /opt/asdf-vm/asdf.sh

# zoxide (better cd)
# Check that zoxide exists in the path
# if command -v zoxide > /dev/null 2>&1; then
#    eval "$(zoxide init zsh)"
# fi

# added by travis gem
[ -f /home/phc/.travis/travis.sh ] && source /home/phc/.travis/travis.sh
export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH"
export MANPATH="$HOME/.local/share/man:$MANPATH"
export TERMINFO="$HOME/.local/share/terminfo"  # tmux needs this
export PATH="/home/phc/.pixi/bin:$PATH"

eval "$(pixi completion --shell zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
