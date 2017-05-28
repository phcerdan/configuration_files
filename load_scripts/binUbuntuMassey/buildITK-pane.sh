#!/bin/bash
export CTEST_ARGS='-R Wavelet'
build_dir=~/Software/ITK/build/
function test(){
    make test -C $build_dir ARGS=$CTEST_ARGS
}

script_dir=$(dirname "$(readlink -f "$0")")
# echo "Sourcing code coverage: $script_dir"
source "$script_dir/coverage.sh"
