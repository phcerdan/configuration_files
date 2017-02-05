#!/bin/env bash

# .gdbinit from https://github.com/cyrus-and/gdb-dashboard, install in $HOME
if [ ! -f "$HOME/.gdbinit" ]; then
    wget -P ~ https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit
else
    echo "$HOME/.gdbinit file exists. Symlink not created."
fi

# .gdb folder
if [ ! -d "$HOME/.gdb" ]; then
    SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    ln -s $SCRIPT_DIR/gdb/.gdb $HOME
    # install external git pretty-printers. External repos are ignored from .gitignore
    git clone https://github.com/mateidavid/Boost-Pretty-Printer ~/.gdb/Boost-Pretty-Printer
else
    echo "$HOME/.gdb folder exists. Do Nothing."
fi

