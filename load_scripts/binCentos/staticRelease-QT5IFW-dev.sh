#!/bin/bash
export qt5IFWStaticRelease_folder=~/Software/Qt5/installer-framework
if echo $qt5IFWStaticRelease_loaded |grep -q 'loaded'
then
	echo "qt5IFWStaticRelease already loaded"
else
	export qt5IFWStaticRelease_loaded='loaded'
	export PATH=$qt5IFWStaticRelease_folder/bin:$PATH
	export LD_LIBRARY_PATH=$qt5IFWStaticRelease_folder/lib:$LD_LIBRARY_PATH
    echo 'Module qt5IFWStaticRelease loaded'
fi
