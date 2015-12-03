#!/bin/bash
export itk_folder=~/Software/ITK/install-release-qt4
export vtk_folder=~/Software/VTK/install-release-qt4
if echo $itk_loaded |grep -q 'loaded'
then
	echo "itk already loaded"
else
	export itk_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$itk_folder/bin:$PATH
	export PATH=$vtk_folder/bin:$PATH
	export LD_LIBRARY_PATH=$itk_folder/lib:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=$vtk_folder/lib:$LD_LIBRARY_PATH
    echo 'Module itk loaded'
fi
