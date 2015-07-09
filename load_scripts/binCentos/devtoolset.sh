#!/bin/bash
#YOU HAVE TO EXECUTE THIS AS SOURCE TO HAVE EFFECT

if echo $devtoolsetloaded |grep -q 'loaded'
then
	echo "devtoolset already loaded"
else
	export devtoolsetloaded="loaded"
	export oldPATH=$PATH
	export oldLD_LIBRARY_PATH=$LD_LIBRARY_PATH
	devtoolsethome=/home/phc/devtoolset
	export PATH=$devtoolsethome/bin:$PATH
	export LD_LIBRARY_PATH="$devtoolsethome/lib:$devtoolsethome/lib64:$LD_LIBRARY_PATH"
	echo "Module devtoolset loaded"
fi
