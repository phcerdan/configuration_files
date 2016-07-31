# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
# window_root "~/tmp"
new_window "vim"
#little hack to load vim-airline theme in tmux...
run_cmd "vim -c 'q' ; clear"

