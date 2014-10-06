#!/bin/bash
export script_folder=/home/phc/bin
export openfoam_folder=/home/phc/Software/OpenFOAM/foam-extend-3.0

if echo $openfoam_extended_loaded |grep -q 'loaded'
then
	echo "openfoam_extended already loaded"
else
	export openfoam_extended_loaded='loaded'
	echo 'Load gcctools...'
	source $script_folder/gcctools-4.8.1.sh
	echo ''
#	echo 'Load qt4...'
#	source $script_folder/qt4-module.sh
#	echo ''
	export FOAM_INST_DIR=/home/phc/Software/OpenFOAM 
	echo "source $openfoam_folder/etc/prefs.sh"
	echo "source $openfoam_folder/etc/bashrc"
	source $openfoam_folder/etc/bashrc
fi
