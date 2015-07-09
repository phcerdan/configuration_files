#!/bin/bash
export ffmpeg_folder=/home/phc/devtoolset/ffmpeg
if echo $ffmpeg_loaded |grep -q 'loaded'
then
	echo "ffmpeg already loaded"
else
	export ffmpeg_loaded='loaded'
	#Modify path for dependancies of OPENFOAM: CGAL
	export PATH=$ffmpeg_folder/bin:$PATH
	export LD_LIBRARY_PATH=$ffmpeg_folder/lib:$LD_LIBRARY_PATH
    echo 'Module ffmpeg loaded'
	# echo ''
	# echo 'PATH:'$PATH
	# echo ''
	# echo 'LD_LIBRARY_PATH:'$LD_LIBRARY_PATH
fi
