#!/bin/bash
export R_folder=/home/phc/devtoolset/R
if echo $R_loaded |grep -q 'loaded'
then
	echo "R already loaded"
else
	export R_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$R_folder/bin:$PATH
    # export R_HOME=$R_folder
	# export LD_LIBRARY_PATH=$R_folder/lib:$LD_LIBRARY_PATH
    echo 'Module R loaded'
fi
