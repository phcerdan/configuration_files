#!/bin/bash
#YOU HAVE TO EXECUTE THIS AS SOURCE TO HAVE EFFECT

if echo $opencv |grep -q 'loaded'
then
	echo "opencv already loaded"
else
	export opencv="loaded"
	export oldPATH=$PATH
	export oldLD_LIBRARY_PATH=$LD_LIBRARY_PATH
	source /home/phc/bin/gcctools-4.8.1.sh
	source /home/phc/bin/python27.sh
	opencvhome=/home/phc/Software/opencv/installation/qt5vtk62python27noffmpeg
	export PATH=$opencvhome/bin:$PATH
	
	export LD_LIBRARY_PATH="$opencvhome/lib:$LD_LIBRARY_PATH"
	echo "PATH= $PATH "
	echo "LD_LIBRARY_PATH= $LD_LIBRARY_PATH"
fi
