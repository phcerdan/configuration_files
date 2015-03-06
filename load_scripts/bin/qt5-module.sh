#!/bin/bash
export qt5_folder=/home/phc/Software/Qt5/qt5/qtbase
if echo $qt5_loaded |grep -q 'loaded'
then
	echo "qt5 already loaded"
else
	export qt5_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$qt5_folder/bin:$PATH
	export LD_LIBRARY_PATH=$qt5_folder/lib:$LD_LIBRARY_PATH
    echo 'Module qt5 loaded'
	# echo ''
	# echo 'PATH:'$PATH
	# echo ''
	# echo 'LD_LIBRARY_PATH:'$LD_LIBRARY_PATH
fi
