import subprocess
def tmux_layout_options():
    gdb.execute("dashboard source -style context 8")

def tmux_layout():
    """Layout for gdb-dashboard using tmux panes"""
    panes_tty = subprocess.getoutput(["tmux lsp -F'#{pane_tty}'"]).split('\n')
    print("$panes_tty =", panes_tty)
    gdb.execute("set $panes_tty = " + "\"" + ",".join(panes_tty)+ "\"")

    gdb.execute("dashboard source -output " + panes_tty[1])
    gdb.execute("dashboard -output " + panes_tty[2])
    gdb.execute("dashboard stacklocals -output " + panes_tty[3])
    gdb.execute("dashboard history -output " + panes_tty[4])

    tmux_layout_options()

