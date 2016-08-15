#!/bin/bash
source ~/bin/devtoolset-debug.sh
export vtk_debug_folder=/home/phc/devtoolset/debug/VTK
export itk_debug_folder=/home/phc/devtoolset/debug/ITK
if echo $vtk_itk_debug_loaded |grep -q 'loaded'
then
	echo "vtk_itk_debug already loaded"
else
	export vtk_itk_debug_loaded='loaded'
	export PATH=$vtk_debug_folder/bin:$PATH
	export PATH=$itk_debug_folder/bin:$PATH
	export LD_LIBRARY_PATH=$vtk_debug_folder/lib:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=$itk_debug_folder/lib:$LD_LIBRARY_PATH
    echo 'Module vtk_itk_debug loaded'
fi
