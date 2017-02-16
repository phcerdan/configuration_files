# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
#window_root "~/Projects/R"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "voltron-lldb"
# Create vertical splits (3)
run_cmd "echo 1"
split_v 65 1
run_cmd "echo 2"
split_v 50 2
run_cmd "echo 3"

# First row:
split_h 50 1
split_h 50
select_pane 1
run_cmd "~/.local/bin/voltron view stack"
select_pane 2
run_cmd "~/.local/bin/voltron view bp"
select_pane 3
run_cmd "~/.local/bin/voltron view disasm"
#
# Run debugger in the middle row
select_pane 4
run_cmd "lldb"
split_h 50 4
run_cmd 'voltron view command --lexer c "source list -a \$rip -c 25" '
#
# # Last row:
# split_h 50 3
select_pane 5
run_cmd "echo 7"
# run_cmd "~/.local/bin/voltron view backtrace"
# select_pane 6
# run_cmd "~/.local/bin/voltron view command"
