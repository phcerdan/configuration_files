# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "~"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "eclimdSource"

# Split window into panes.
# split_v 20
split_h 30

# Run commands.
run_cmd "cd ~/Software/eclipse"     # runs in active pane
run_cmd "export SWT_GTK3=0" # bug in eclipse Kepler/Luna/Mars
run_cmd "eclimdSource"
#run_cmd "date" 1  # runs in pane 1

# Paste text
# send_keys "./eclimd"    # paste into active pane
#send_keys "date" 1 # paste into pane 1

# Set active pane.
#select_pane 0
