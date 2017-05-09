# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/Software/DGtal/"
# get_distro="lsb_release -si";

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "dgtal"; then

  # Create a new window inline within session layout definition.
  new_window "vim"
  run_cmd "vim -S Session.vim"
  new_window "build"
  run_cmd "cd ./build"
  split_h 50
  run_cmd "cd ./build"
  # load_window "org"
  load_window "eclimd"
  # Select the default active window on session creation.
  select_window 2

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session

