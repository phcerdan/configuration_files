import subprocess
def tmux_layout_options():
    gdb.execute("dashboard source -style context 8")

def tmux_layout():
    """Layout for gdb-dashboard using tmux panes"""
    # Bug? Cursor (in the terminal) is gone in any tmux pane after this function.
    panes_tty = subprocess.getoutput(["tmux lsp -F'#{pane_tty}'"]).split('\n')
    panes_id = subprocess.getoutput(["tmux lsp -F'#{pane_id}'"]).split('\n')
    print("panes_tty =", panes_tty)
    if len(panes_tty) == 2:
        # Put the outout in the right pane, and enable history and stacklocals
        gdb.execute("dashboard -layout !stacklocals stack history !threads source")
        # gdb.execute("dashboard -output " + panes_tty[1])
        # gdb.execute("dashboard stacklocals -output " + panes_tty[1])
        right_tty = panes_tty[1]
        gdb.execute("dashboard stack -output "   + right_tty)
        gdb.execute("dashboard history -output " + right_tty)
        gdb.execute("dashboard source -output "  + right_tty)
    if len(panes_tty) == 3:
        # NOTE: Execute tmux_split_gdb (from ~/.tmux_utils)
        gdb.execute("dashboard -layout stacklocals stack history !threads source")
        # gdb.execute("dashboard -output " + panes_tty[1])
        right_tty = panes_tty[2]
        up_index = 0
        up_tty = panes_tty[up_index]
        gdb.execute("dashboard stacklocals -output " + right_tty)
        gdb.execute("dashboard stack -output "       + right_tty)
        gdb.execute("dashboard history -output "     + right_tty)
        gdb.execute("dashboard source -output "      + up_tty)
        pane_source_height = subprocess.getoutput(["tmux lsp -F'#{pane_height}'"]).split('\n')[up_index]
        gdb.execute("dashboard source -style context " + str(int(int(pane_source_height)/2.1)))

        
    # Not needed, should be in .gdbinit.d/auto already
    # tmux_layout_options()

