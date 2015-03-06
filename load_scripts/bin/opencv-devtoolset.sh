#!/bin/bash
export opencv_folder=/home/phc/devtoolset/opencv
if echo $opencv_loaded |grep -q 'loaded'
then
	echo "opencv already loaded"
else
	export opencv_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$opencv_folder/bin:$PATH
	export LD_LIBRARY_PATH=$opencv_folder/lib:$LD_LIBRARY_PATH
    echo 'Module opencv loaded'
	# echo ''
	# echo 'PATH:'$PATH
	# echo ''
	# echo 'LD_LIBRARY_PATH:'$LD_LIBRARY_PATH
fi
