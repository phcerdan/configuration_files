#!/bin/bash
export qt5Static_folder=~/Software/Qt5/qt5Static/qtbase
if echo $qt5Static_loaded |grep -q 'loaded'
then
	echo "qt5 already loaded"
else
	export qt5Static_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$qt5Static_folder/bin:$PATH
	export LD_LIBRARY_PATH=$qt5Static_folder/lib:$LD_LIBRARY_PATH
    echo 'Module qt5Static loaded'
	# echo ''
	# echo 'PATH:'$PATH
	# echo ''
	# echo 'LD_LIBRARY_PATH:'$LD_LIBRARY_PATH
fi
