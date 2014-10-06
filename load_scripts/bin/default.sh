#!/bin/bash
if echo $gcctoolsloaded |grep -q 'loaded'
then
	echo "you have to execute this with \"source default.sh\" to have effect"
	export PATH=$oldPATH
	export LD_LIBRARY_PATH=$oldLD_LIBRARY_PATH
	export gcctoolsloaded=
	echo "PATH= $PATH "
	echo "LD_LIBRARY_PATH= $LD_LIBRARY_PATH"
	echo "gcctools was loaded but... UNDOING"
	echo "EXECUTE sudo ldconfig"
else
	echo "PATH= $PATH "
	echo "LD_LIBRARY_PATH= $LD_LIBRARY_PATH"
	echo "The PATH was not modified with any configured scripts"
	echo "Open a new terminal to get the default path"
	
fi