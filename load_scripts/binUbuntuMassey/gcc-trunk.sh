#!/bin/bash
export gcc_trunk_folder=/home/phc/Software/gcc/gcc-install
if echo $gcc_trunk_loaded |grep -q 'loaded'
then
	echo "gcc_trunk already loaded"
else
	export gcc_trunk_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$gcc_trunk_folder/bin:$PATH
	export LD_LIBRARY_PATH=$gcc_trunk_folder/lib:$LD_LIBRARY_PATH
    echo 'Module gcc_trunk loaded'
fi
