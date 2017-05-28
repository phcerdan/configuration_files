#!/bin/bash
# GCOV_PREFIX and GCOV_PREFIX_STRIP are env variables for lcov to change where .gcda files are generated http://bobah.net/book/export/html/2
export COVERAGE_PREFIX="$HOME/Software/ITK/build/Modules/Remote/IsotropicWavelets/test/CMakeFiles/IsotropicWaveletsTestDriver.dir"

function lcovclean(){
    lcov --directory $COVERAGE_PREFIX --zerocounters
}

function lcovrun(){
    lcov --directory $COVERAGE_PREFIX --capture --output-file $COVERAGE_PREFIX/app.info
}

function lcovgen(){
    genhtml --output-directory $COVERAGE_PREFIX/coverage \
            --demangle-cpp --num-spaces 2 --sort \
            --title "Coverage" \
            --function-coverage --branch-coverage --legend \
            $COVERAGE_PREFIX/app.info
}

function lcovopen(){
    firefox $COVERAGE_PREFIX/coverage/index.html &
}

function cleantest(){
    lcovclean && test
}

function dolcov(){
    lcovrun && lcovgen && lcovopen
}

function lcovall(){
    cleantest && dolcov
}
