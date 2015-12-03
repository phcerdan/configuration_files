#!/bin/bash
source /home/phc/bin/devtoolset-core.sh
export devtoolset_debug_folder=/home/phc/devtoolset/debug
if echo $devtoolset_debug_loaded |grep -q 'loaded'
then
	echo "devtoolset_debug already loaded"
else
	export devtoolset_debug_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$devtoolset_debug_folder/bin:$PATH
	export LD_LIBRARY_PATH=$devtoolset_debug_folder/lib:$LD_LIBRARY_PATH
    echo 'Module devtoolset_debug loaded'
fi

