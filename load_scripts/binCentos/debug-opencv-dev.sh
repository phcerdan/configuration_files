#!/bin/bash
export opencv_debug_folder=~/devtoolset/debug/opencv
if echo $opencv_debug_loaded |grep -q 'loaded'
then
	echo "opencv_debug already loaded"
else
	export opencv_debug_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$opencv_debug_folder/bin:$PATH
	export LD_LIBRARY_PATH=$opencv_debug_folder/lib:$LD_LIBRARY_PATH
    echo 'Module opencv_debug loaded'
fi
