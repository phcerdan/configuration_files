#!/bin/bash
export devtoolset_core_folder=/home/phc/devtoolset
if echo $devtoolset_core_loaded |grep -q 'loaded'
then
	echo "devtoolset_core already loaded"
else
	export devtoolset_core_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$devtoolset_core_folder/bin:$PATH
	export LD_LIBRARY_PATH=$devtoolset_core_folder/lib:$LD_LIBRARY_PATH
    echo 'Module devtoolset_core loaded'
fi

