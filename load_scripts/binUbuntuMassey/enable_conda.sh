#!/bin/bash
export conda_folder=/home/phc/miniconda3
if echo $conda_loaded |grep -q 'loaded'
then
	echo "conda already loaded"
else
	export conda_loaded='loaded'
	export PATH=$conda_folder/bin:$PATH
    echo 'Module conda loaded'
fi

