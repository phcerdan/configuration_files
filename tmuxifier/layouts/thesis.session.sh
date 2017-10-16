# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
session_root "~/repository_local/thesis-git"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "thesis"; then
  new_window "vim"
  # run_cmd "viserver -S Session.vim"
  run_cmd "vim -S Session.vim"
  new_window "git-emacs"
  split_h 50
  run_cmd "emacs --daemon ; orgthesis"
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
