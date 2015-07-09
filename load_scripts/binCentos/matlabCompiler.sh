#!/bin/bash
if echo $matlabCompiler_loaded |grep -q 'loaded'
then
	echo "matlabCompiler already loaded"
else
	export matlabCompiler_loaded='loaded'
	export LD_LIBRARY_PATH=/usr/local/MATLAB/MATLAB_Compiler_Runtime/v81/runtime/glnxa64:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v81/bin/glnxa64:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v81/sys/os/glnxa64:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v81/sys/java/jre/glnxa64/jre/lib/amd64/native_threads:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v81/sys/java/jre/glnxa64/jre/lib/amd64/server:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v81/sys/java/jre/glnxa64/jre/lib/amd64:$LD_LIBRARY_PATH
    export XAPPLRESDIR=/usr/local/MATLAB/MATLAB_Compiler_Runtime/v81/X11/app-defaults
    echo 'Module matlabCompiler loaded'
fi
