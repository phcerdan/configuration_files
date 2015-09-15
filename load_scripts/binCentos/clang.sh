#!/bin/bash
export clang_folder=~/devtoolset/clang
if echo $clang_loaded |grep -q 'loaded'
then
	echo "clang already loaded"
else
	export clang_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$clang_folder/bin:$PATH
	export LD_LIBRARY_PATH=$clang_folder/lib:$LD_LIBRARY_PATH
    echo 'Module clang loaded'
fi
