# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
# window_root "~/Software/ITK/build"

new_window "buildITK"
run_cmd "export BUILD_FOLDER=build-clang-development"
run_cmd 'cd "$BUILD_FOLDER"'
run_cmd "export CTEST_ARGS='-R Wavelet'"
run_cmd 'function test(){make test -C $TMUXIFIER_SESSION_ROOT/$BUILD_FOLDER ARGS=$CTEST_ARGS}'
