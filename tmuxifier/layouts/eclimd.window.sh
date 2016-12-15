# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
# window_root "~/repository_local"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "eclimd"

# Split window into panes.
# split_v 20
split_h 20

# Run commands.
run_cmd "cd ~/Software/eclipse"     # runs in active pane
# not needed if .eclipse.init is modified (recommended)
# run_cmd "export SWT_GTK3=0" # bug in eclipse Kepler/Luna/Mars
run_cmd "./eclimd"

# send_keys "./eclimd"    # paste into active pane
