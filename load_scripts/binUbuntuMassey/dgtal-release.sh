#!/bin/bash
source ~/bin/vtk-itk-release.sh
export dgtal_release_folder=/home/phc/devtoolset/release/VTK
if echo $dgtal_release_loaded |grep -q 'loaded'
then
	echo "dgtal_release already loaded"
else
	export dgtal_release_loaded='loaded'
	export PATH=$dgtal_release_folder/bin:$PATH
	export LD_LIBRARY_PATH=$dgtal_release_folder/lib:$LD_LIBRARY_PATH
    echo 'Module dgtal_release loaded'
fi
