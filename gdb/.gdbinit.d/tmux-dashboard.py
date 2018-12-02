import subprocess
def tmux_layout_options():
    gdb.execute("dashboard source -style context 8")

def tmux_layout():
    """Layout for gdb-dashboard using tmux panes"""
    # Bug? Cursor (in the terminal) is gone in any tmux pane after this function.
    panes_tty = subprocess.getoutput(["tmux lsp -F'#{pane_tty}'"]).split('\n')
    print("panes_tty =", panes_tty)
    # gdb.execute("set $panes_tty = " + "\"" + ",".join(panes_tty)+ "\"")
    # gdb.execute("dashboard -layout source stack assembly !threads")
    if len(panes_tty) > 1:
        # Put the outout in the right pane, and enable history and stacklocals
        gdb.execute("dashboard -output " + panes_tty[1])
        gdb.execute("dashboard source -output " + panes_tty[0])
        gdb.execute("dashboard stacklocals -output " + panes_tty[1])
        gdb.execute("dashboard history -output " + panes_tty[1])
    # if len(panes_tty) > 2:
    #     gdb.execute("dashboard source -output " + panes_tty[2])

    # Not needed, should be in .gdbinit.d/auto already
    # tmux_layout_options()

