#!/bin/bash
echo "Reset to default PATH and LD_LIBRARY_PATH. Hard-coded, check this script is up-to-date"
export PATH="/usr/lib64/qt-3.3/bin:/usr/lib64/openmpi/bin:/shared/numerical_libs/bin:/usr/local/MATLAB/R2012b/bin:/usr/local/cuda/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/phc/bin"
export LD_LIBRARY_PATH=""
echo "PATH: $PATH"
echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"
