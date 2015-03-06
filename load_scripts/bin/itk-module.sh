#!/bin/bash
export itk_folder=/home/phc/devtoolset/ITK
if echo $itk_loaded |grep -q 'loaded'
then
	echo "itk already loaded"
else
	export itk_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$itk_folder/bin:$PATH
	export LD_LIBRARY_PATH=$itk_folder/lib:$LD_LIBRARY_PATH
    echo 'Module itk loaded'
	# echo ''
	# echo 'PATH:'$PATH
	# echo ''
	# echo 'LD_LIBRARY_PATH:'$LD_LIBRARY_PATH
fi
