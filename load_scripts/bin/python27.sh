#!/bin/bash
#YOU HAVE TO EXECUTE THIS AS SOURCE TO HAVE EFFECT

if echo $python27 |grep -q 'loaded'
then
	echo "python27 already loaded"
else
	export python27="loaded"
	export oldPATH=$PATH
	export oldLD_LIBRARY_PATH=$LD_LIBRARY_PATH
	
	python27home=/shared/python27
	export PATH=$python27home/bin:$PATH
	
	export LD_LIBRARY_PATH="$python27home/lib:$LD_LIBRARY_PATH"
	echo "PATH= $PATH "
	echo "LD_LIBRARY_PATH= $LD_LIBRARY_PATH"
fi
