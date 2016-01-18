#!/bin/bash
source ~/bin/devtoolset-release.sh
export vtk_release_folder=/home/phc/devtoolset/release/VTK
export itk_release_folder=/home/phc/devtoolset/release/ITK
if echo $vtk_itk_release_loaded |grep -q 'loaded'
then
	echo "vtk_itk_release already loaded"
else
	export vtk_itk_release_loaded='loaded'
	export PATH=$vtk_release_folder/bin:$PATH
	export PATH=$itk_release_folder/bin:$PATH
	export LD_LIBRARY_PATH=$vtk_release_folder/lib:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=$itk_release_folder/lib:$LD_LIBRARY_PATH
    echo 'Module vtk_itk_release loaded'
fi
