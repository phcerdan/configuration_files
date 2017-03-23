# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "~/Software/ITK/build"

new_window "buildITK"
run_cmd "source ~/bin/buildITK-pane.sh"
split_h 50
run_cmd "source ~/bin/buildITK-pane.sh"
