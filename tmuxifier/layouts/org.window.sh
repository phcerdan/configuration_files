# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
# window_root "~/tmp"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "org-mode"

# Split window into panes.
# split_v 20
# split_h 20
# select_pane 0

# Run commands: This is an alias to open emacs with agenda: check ~/.aliases
run_cmd "org"     # runs in active pane

# Set active pane.
#select_pane 0
