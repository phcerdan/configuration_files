#!/bin/bash
export qt5StaticRelease_folder=~/Software/Qt5/qt5Static/qtbase
if echo $qt5StaticRelease_loaded |grep -q 'loaded'
then
	echo "qt5StaticRelease already loaded"
else
	export qt5StaticRelease_loaded='loaded'
	export PATH=$qt5StaticRelease_folder/bin:$PATH
	export LD_LIBRARY_PATH=$qt5StaticRelease_folder/lib:$LD_LIBRARY_PATH
    echo 'Module qt5StaticRelease loaded'
fi
