# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "cling"

# Split window into panes.
split_h 35
#split_h 50

# Run commands.
run_cmd "cling"
select_pane 1
