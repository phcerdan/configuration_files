#!/bin/bash
export vtk_release_folder=/home/phc/devtoolset/release/VTK
if echo $vtk_release_loaded |grep -q 'loaded'
then
	echo "vtk_release already loaded"
else
	export vtk_release_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$vtk_release_folder/bin:$PATH
	export LD_LIBRARY_PATH=$vtk_release_folder/lib:$LD_LIBRARY_PATH
    echo 'Module vtk_release loaded'
fi
