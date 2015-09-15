#!/bin/bash
source ~/bin/core-dev.sh
# source ~/bin/debug-VTK-dev.sh
# source ~/bin/debug-ITK-dev.sh
# source ~/bin/debug-opencv-dev.sh
echo "scl ENABLED: devtoolset-3 python33 python27 git19"
scl enable devtoolset-3 python33 python27 git19 bash
echo "scl DISABLED: devtoolset-3 python33 python27 git19"
