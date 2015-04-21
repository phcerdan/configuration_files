#!/bin/bash
export itk_release_folder=/home/phc/devtoolset/release/ITK
if echo $itk_release_loaded |grep -q 'loaded'
then
	echo "itk_release already loaded"
else
	export itk_release_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$itk_release_folder/bin:$PATH
	export LD_LIBRARY_PATH=$itk_release_folder/lib:$LD_LIBRARY_PATH
    echo 'Module itk_release loaded'
fi
