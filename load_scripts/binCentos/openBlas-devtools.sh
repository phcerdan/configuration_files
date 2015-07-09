#!/bin/bash
export open_blas_folder=/home/phc/devtoolset/numerical_libs/OpenBLAS
if echo $open_blas_loaded |grep -q 'loaded'
then
	echo "open_blas already loaded"
else
	export open_blas_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	# export PATH=$open_blas_folder/bin:$PATH
	export LD_LIBRARY_PATH=$open_blas_folder/lib:$LD_LIBRARY_PATH
    echo 'Module open_blas loaded'
fi
