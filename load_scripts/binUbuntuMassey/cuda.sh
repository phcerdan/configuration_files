#!/bin/bash
export cuda_folder=/usr/local/cuda
if echo $cuda_loaded |grep -q 'loaded'
then
	echo "cuda already loaded"
else
	export cuda_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$cuda_folder/bin:$PATH
	export LD_LIBRARY_PATH=$cuda_folder/lib:$LD_LIBRARY_PATH
    echo 'Module cuda loaded'
	# echo ''
	# echo 'PATH:'$PATH
	# echo ''
	# echo 'LD_LIBRARY_PATH:'$LD_LIBRARY_PATH
fi
