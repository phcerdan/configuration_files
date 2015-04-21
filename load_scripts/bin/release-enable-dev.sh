#!/bin/bash
source ~/bin/core-dev.sh
source ~/bin/release-ALL.sh
echo "scl ENABLED: devtoolset-3 python33 python27 git19"
scl enable devtoolset-3 python33 python27 git19 bash
echo "scl DISABLED: devtoolset-3 python33 python27 git19"
