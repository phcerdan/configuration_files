# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
#window_root "~/Projects/R"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "gdb-dashboard"
split_h 66
split_h 33
split_v 40 3
split_v 66 2

select_pane 1
run_cmd "gdb"
sleep 2
send_keys "python tmux_layout()"
send_keys Enter
