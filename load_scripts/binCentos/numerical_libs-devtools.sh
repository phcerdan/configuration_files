#!/bin/bash
export numerical_libs_folder=~/devtoolset/numerical_libs
if echo $numerical_libs_loaded |grep -q 'loaded'
then
	echo "numerical_libs already loaded"
else
	export numerical_libs_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$numerical_libs_folder/bin:$PATH
	export LD_LIBRARY_PATH=$numerical_libs_folder/lib:$LD_LIBRARY_PATH
    source ~/bin/openBlas-devtools.sh
    source ~/bin/lapack-devtools.sh
    echo 'Module numerical_libs loaded'
	# echo ''
	# echo 'PATH:'$PATH
	# echo ''
	# echo 'LD_LIBRARY_PATH:'$LD_LIBRARY_PATH
fi
