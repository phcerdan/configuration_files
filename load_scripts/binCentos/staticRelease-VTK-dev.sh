#!/bin/bash
export vtk_staticRelease_folder=~/devtoolset/staticRelease/VTK
if echo $vtk_staticRelease_loaded |grep -q 'loaded'
then
	echo "vtk_staticRelease already loaded"
else
	export vtk_staticRelease_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$vtk_staticRelease_folder/bin:$PATH
	export LD_LIBRARY_PATH=$vtk_staticRelease_folder/lib:$LD_LIBRARY_PATH
    echo 'Module vtk_staticRelease loaded'
fi
