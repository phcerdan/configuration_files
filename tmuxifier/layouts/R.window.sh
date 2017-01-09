# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
#window_root "~/Projects/R"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "R"
split_h 50
run_cmd "export R_LIBS='/home/phc/R/x86_64-pc-linux-gnu-library/3.2:$R_LIBS'"
run_cmd "R"
select_pane 1
# Split window into panes.
#split_v 20

# Run commands.
#run_cmd "top"     # runs in active pane
#run_cmd "date" 1  # runs in pane 1

# Paste text
#send_keys "top"    # paste into active pane
#send_keys "date" 1 # paste into pane 1

# Set active pane.
#select_pane 0
