# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
# window_root "~/tmp"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "other-org"

# Split window into panes.
# split_v 20
split_h 50
# select_pane 0

# Run commands: This is an alias to open emacs with agenda: check ~/.aliases
run_cmd "emacs --daemon ; orgclient"

# Set active pane.
#select_pane 0
