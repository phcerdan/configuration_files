#!/bin/bash
export lapack_folder=/home/phc/devtoolset/numerical_libs/Lapack
if echo $lapack_loaded |grep -q 'loaded'
then
	echo "lapack already loaded"
else
	export lapack_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	# export PATH=$lapack_folder/bin:$PATH
	export LD_LIBRARY_PATH=$lapack_folder/lib:$LD_LIBRARY_PATH
    echo 'Module lapack loaded'
fi
