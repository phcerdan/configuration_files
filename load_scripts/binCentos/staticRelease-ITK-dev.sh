#!/bin/bash
export itk_staticRelease_folder=~/devtoolset/staticRelease/ITK
if echo $itk_staticRelease_loaded |grep -q 'loaded'
then
	echo "itk_staticRelease already loaded"
else
	export itk_staticRelease_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$itk_staticRelease_folder/bin:$PATH
	export LD_LIBRARY_PATH=$itk_staticRelease_folder/lib:$LD_LIBRARY_PATH
    echo 'Module itk_staticRelease loaded'
fi
