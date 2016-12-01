# Must be called before `new_window`.
#window_root "~/Projects/python"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "sitk"

# Split window into panes.
split_h 35
#split_h 50

# Run commands.

# run_cmd 'export SITK_SHOW_COMMAND="%a -o %f"'

run_cmd 'export SITK_SHOW_COMMAND="/home/phc/Software/ITK/build-dev-cpp98/bin/IsotropicWaveletsTestDriver runViewImage %f"'
run_cmd "source ~/repository_local/simpleitk/bin/activate"
run_cmd "ipython2"
select_pane 1
#run_cmd "date" 1  # runs in pane 1

# Paste text
#send_keys "top"    # paste into active pane
#send_keys "date" 1 # paste into pane 1

# Set active pane.
#select_pane 0
