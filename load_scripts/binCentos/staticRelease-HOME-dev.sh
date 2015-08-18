#!/bin/bash
export staticRelease_folder=~/devtoolset/staticRelease
if echo $staticRelease_loaded |grep -q 'loaded'
then
	echo "staticRelease already loaded"
else
	export staticRelease_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$staticRelease_folder/bin:$PATH
	export LD_LIBRARY_PATH=$staticRelease_folder/lib:$LD_LIBRARY_PATH
    echo 'Module staticRelease loaded'
fi
