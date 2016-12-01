#!/bin/bash
export CTEST_ARGS='-R Wavelet'
build_dir=~/Software/ITK/build/
function test(){make test -C $build_dir ARGS=$CTEST_ARGS}
