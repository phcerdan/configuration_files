#!/bin/bash
#This script is incldued in numericallibs.sh
if echo $openblasloaded |grep -q 'loaded'
then
	echo "openblas-script already loaded"
else
	echo "you have to execute this with \"source openblas-script.sh\" to have effect"
	export openblasloaded="loaded"
	export oldPATH=$PATH
	export oldLD_LIBRARY_PATH=$LD_LIBRARY_PATH
	

	openblashome=/shared/numerical_libs/openblas_4.8

	#export PATH=$openblashome/bin:$PATH
	
	#export LD_LIBRARY_PATH="$gcctoolshome/lib:$gcctoolshome/lib64:$LD_LIBRARY_PATH"
	export LD_LIBRARY_PATH="$openblashome/lib:$LD_LIBRARY_PATH"
	echo "PATH= $PATH "
	echo "LD_LIBRARY_PATH= $LD_LIBRARY_PATH"
	echo "added to the LD_LIBRARY_PATH: $openblashome/lib"
	#	echo "To return to the older path execute /home/phc/bin/default.sh "
	echo "Module openblascript loaded, this module is included in numericalibs-script.sh"
	echo "EXECUTE sudo ldconfig"
fi