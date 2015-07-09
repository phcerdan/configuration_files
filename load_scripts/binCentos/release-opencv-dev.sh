#!/bin/bash
export opencv_release_folder=/home/phc/devtoolset/release/opencv
if echo $opencv_release_loaded |grep -q 'loaded'
then
	echo "opencv_release already loaded"
else
	export opencv_release_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$opencv_release_folder/bin:$PATH
	export LD_LIBRARY_PATH=$opencv_release_folder/lib:$LD_LIBRARY_PATH
    echo 'Module opencv_release loaded'
fi
