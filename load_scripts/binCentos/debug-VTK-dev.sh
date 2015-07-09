#!/bin/bash
export vtk_debug_folder=/home/phc/devtoolset/debug/VTK
if echo $vtk_debug_loaded |grep -q 'loaded'
then
	echo "vtk_debug already loaded"
else
	export vtk_debug_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$vtk_debug_folder/bin:$PATH
	export LD_LIBRARY_PATH=$vtk_debug_folder/lib:$LD_LIBRARY_PATH
    echo 'Module vtk_debug loaded'
fi
