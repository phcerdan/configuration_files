# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
alias fe30='source $HOME/Software/OpenFOAM/foam-extend-3.0/etc/bashrc'
alias v='gvim -v'
alias sgcctools='source /home/phc/bin/gcctools-4.8.1.sh'
alias sopencv='source /home/phc/bin/opencv.sh'

# Add vi commands (different copy/paste than terminal)
# set -o vi

# FOR tmux: from http://opennomad.com/content/goodbye-screen-hello-tmux
# Color stuff
if [ $TERM == "xterm" ]; then #  && [ $COLORTERM == "gnome-terminal" ]; then
    # echo hello $TERM $COLORTERM
    export TERM=xterm-256color
fi

# # Right naming when ssh: (from http://opennomad.com/content/goodbye-screen-hello-tmux )
# case $TERM in
#     xterm*|rxvt)
#         # PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}\007"'
#         PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}@${PWD##*/}/\007"'
#         export PROMPT_COMMAND
#         ;;
#     screen*)
#       TITLE=$(hostname -s)                                                      
#       # PROMPT_COMMAND='/bin/echo -ne "\033k${TITLE}\033\\"'                      
#       PROMPT_COMMAND='/bin/echo -ne "\033]0;${HOSTNAME}@${PWD##*/}/\007"'
#       # PROMPT_COMMAND='echo -ne "\033]0;\007"'
#       export PROMPT_COMMAND
#         ;;
# esac

# # AUTO UPDATE RIGHT $DISPLAY in tmux.
# # http://alexteichman.com/octo/blog/2014/01/01/x11-forwarding-and-terminal-multiplexers/
# # -- Improved X11 forwarding through GNU Screen (or tmux).
# # If not in screen or tmux, update the DISPLAY cache.
# # If we are, update the value of DISPLAY to be that in the cache.
# # If multiple sessions, deattach and re-attach to update.
# function update-x11-forwarding
# {
#     if [ -z "$STY" -a -z "$TMUX" ]; then
#         echo $DISPLAY > ~/.display.txt
#     else
#         export DISPLAY=`cat ~/.display.txt`
#     fi
# }
#
# # This is run before every command.
# preexec() {
#     # Don't cause a preexec for PROMPT_COMMAND.
#     # Beware!  This fails if PROMPT_COMMAND is a string containing more than one command.
#     [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return 
#
#     update-x11-forwarding
#
#     # Debugging.
#     #echo DISPLAY = $DISPLAY, display.txt = `cat ~/.display.txt`, STY = $STY, TMUX = $TMUX  
# }
# trap 'preexec' DEBUG
