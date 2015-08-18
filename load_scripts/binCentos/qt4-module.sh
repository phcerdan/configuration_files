#!/bin/bash
export qt4_folder=~/Software/Qt4
if echo $q4_loaded |grep -q 'loaded'
then
	echo "qt4 already loaded"
else
	export qt4_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	echo 'Adding Qt4'
	echo 'Modify PATH and LD_LIBRARY_PATH for dependencies...'
	export PATH=$qt4_folder/bin:$PATH
	export LD_LIBRARY_PATH=$qt4_folder/lib:$LD_LIBRARY_PATH
	echo ''
	echo 'PATH:'$PATH
	echo ''
	echo 'LD_LIBRARY_PATH:'$LD_LIBRARY_PATH
fi
