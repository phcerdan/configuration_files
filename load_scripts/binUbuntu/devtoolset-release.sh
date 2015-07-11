#!/bin/bash
export devtoolset_release_folder=/home/phc/devtoolset/release
if echo $devtoolset_release_loaded |grep -q 'loaded'
then
	echo "devtoolset_release already loaded"
else
	export devtoolset_release_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$devtoolset_release_folder/bin:$PATH
	export LD_LIBRARY_PATH=$devtoolset_release_folder/lib:$LD_LIBRARY_PATH
    echo 'Module devtoolset_release loaded'
fi
