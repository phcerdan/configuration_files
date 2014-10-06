#!/bin/bash
export qt5_folder=/home/phc/Software/Qt5/qt5/qtbase
if echo $q5_loaded |grep -q 'loaded'
then
	echo "qt5 already loaded"
else
	export qt5_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	echo 'Adding Qt5'
	echo 'Modify PATH and LD_LIBRARY_PATH for dependencies...'
	export PATH=$qt5_folder/bin:$PATH
	export LD_LIBRARY_PATH=$qt5_folder/lib:$LD_LIBRARY_PATH
	echo ''
	echo 'PATH:'$PATH
	echo ''
	echo 'LD_LIBRARY_PATH:'$LD_LIBRARY_PATH
fi
