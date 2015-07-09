#!/bin/bash
export itk_debug_folder=/home/phc/devtoolset/debug/ITK
if echo $itk_debug_loaded |grep -q 'loaded'
then
	echo "itk_debug already loaded"
else
	export itk_debug_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$itk_debug_folder/bin:$PATH
	export LD_LIBRARY_PATH=$itk_debug_folder/lib:$LD_LIBRARY_PATH
    echo 'Module itk_debug loaded'
fi
