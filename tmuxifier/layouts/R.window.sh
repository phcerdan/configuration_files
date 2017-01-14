# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
#window_root "~/Projects/R"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "R"
run_cmd "export R_LIBS='/home/phc/R/x86_64-pc-linux-gnu-library/3.2:$R_LIBS'"
# with NvimR plugin
run_cmd "vim -c 'set ft=r' ~/tmp/delete_me.R"
sleep 2
# send keys to vim to :call StartR("R"). ; is local leader
send_keys "\;rf"

# with Slime:
# split_h 50
# run_cmd "export R_LIBS='/home/phc/R/x86_64-pc-linux-gnu-library/3.2:$R_LIBS'"
# run_cmd "R"
# select_pane 1
# run_cmd "export R_LIBS='/home/phc/R/x86_64-pc-linux-gnu-library/3.2:$R_LIBS'"
