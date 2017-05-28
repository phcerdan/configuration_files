# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/repository_local/phcerdan.github.io"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "blog"; then
  # Create a new window inline within session layout definition.
  new_window "vim"
  load_window "bundle_jekyll_liveserve"
  select_window 1
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session

