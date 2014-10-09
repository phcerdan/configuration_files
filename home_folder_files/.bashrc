# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Add vi commands.
set -o vi

# User specific aliases and functions
alias fe30='source $HOME/Software/OpenFOAM/foam-extend-3.0/etc/bashrc'
alias v='gvim -v'
alias sgcctools='source /home/phc/bin/gcctools-4.8.1.sh'
alias sopencv='source /home/phc/bin/opencv.sh'
# FOR tmux: from http://opennomad.com/content/goodbye-screen-hello-tmux
# Color stuff
if [ $TERM == "xterm" ] && [ $COLORTERM == "gnome-terminal" ]; then
    # echo hello $TERM $COLORTERM
    export TERM=xterm-256color
fi

# Right naming when ssh: (from http://opennomad.com/content/goodbye-screen-hello-tmux )
case $TERM in
    xterm*|rxvt)
        # PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}\007"'
        PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}@${PWD##*/}/\007"'
        export PROMPT_COMMAND
        ;;
    screen*)
      TITLE=$(hostname -s)                                                      
      # PROMPT_COMMAND='/bin/echo -ne "\033k${TITLE}\033\\"'                      
      PROMPT_COMMAND='/bin/echo -ne "\033]0;${HOSTNAME}@${PWD##*/}/\007"'
      # PROMPT_COMMAND='echo -ne "\033]0;\007"'
      export PROMPT_COMMAND
        ;;
esac
