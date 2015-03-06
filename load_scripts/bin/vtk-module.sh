#!/bin/bash
export vtk_folder=/home/phc/devtoolset/VTK
if echo $vtk_loaded |grep -q 'loaded'
then
	echo "vtk already loaded"
else
	export vtk_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$vtk_folder/bin:$PATH
	export LD_LIBRARY_PATH=$vtk_folder/lib:$LD_LIBRARY_PATH
    echo 'Module vtk loaded'
	# echo ''
	# echo 'PATH:'$PATH
	# echo ''
	# echo 'LD_LIBRARY_PATH:'$LD_LIBRARY_PATH
fi
