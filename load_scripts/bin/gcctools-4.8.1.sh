#!/bin/bash
#YOU HAVE TO EXECUTE THIS AS SOURCE TO HAVE EFFECT

if echo $gcctoolsloaded |grep -q 'loaded'
then
	echo "gcctools already loaded"
else
	#echo "you have to execute this with \"source gcctools-4.8.1.sh\" to have effect"
	export gcctoolsloaded="loaded"
	export oldPATH=$PATH
	export oldLD_LIBRARY_PATH=$LD_LIBRARY_PATH
	
	#gcctoolshome=/home/phc/Software/GCC/gcctools-4.8.1/rtf
	gcctoolshome=/shared/gcctools-4.8.1
	openmpidir=$gcctoolshome/openmpi
	export PATH=$openmpidir/bin:$gcctoolshome/bin:$PATH
	
	#export LD_LIBRARY_PATH="$gcctoolshome/lib:$gcctoolshome/lib64:$LD_LIBRARY_PATH"
	export LD_LIBRARY_PATH="$openmpidir/lib:$gcctoolshome/lib:$gcctoolshome/lib64:$LD_LIBRARY_PATH"
	echo "Module gcctools-4.8.1 loaded"
fi
