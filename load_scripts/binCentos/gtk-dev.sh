#!/bin/bash
export gtk_folder=/home/phc/devtoolset/gtk
if echo $gtk_loaded |grep -q 'loaded'
then
	echo "gtk already loaded"
else
	export gtk_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$gtk_folder/bin:$PATH
	export LD_LIBRARY_PATH=$gtk_folder/lib:$gtk_folder/lib64:$LD_LIBRARY_PATH
    export PKG_CONFIG_PATH=$gtk_folder/lib/pkgconfig:$PKG_CONFIG_PATH
    # export PKG_CONFIG=$gtk_folder/lib/pkgconfig:$PKG_CONFIG_PATH
    echo 'Module gtk loaded'
fi
