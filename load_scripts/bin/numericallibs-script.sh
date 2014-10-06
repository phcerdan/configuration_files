#!/bin/bash
#openblas-script is included here.
if echo $numericallibsloaded |grep -q 'loaded'
then
	echo "numericallibs-script already loaded"
else
	echo "you have to execute this with \"source numericallibs-script.sh\" to have effect"
	export numericallibsloaded="loaded"
	export oldPATH=$PATH
	export oldLD_LIBRARY_PATH=$LD_LIBRARY_PATH
	

	numericallibshome=/shared/numerical_libs
	#All the libs:
	openblasdir=$numericallibshome/openblas_4.8
	scalapackdir=$numericallibshome/scalapack
	fftwdir=$numericallibshome
	petscdir=$numericallibshome/petsc_4.8

	# eigen is only include
	# viennacl is only include
	export PATH=$fftwdir/bin:$petscdir/bin:$PATH
	
	export LD_LIBRARY_PATH=$openblasdir/lib:$scalapackdir/lib:$fftwdir/lib:$petscdir/lib:$LD_LIBRARY_PATH
	echo "PATH= $PATH "
	echo "LD_LIBRARY_PATH= $LD_LIBRARY_PATH"
	echo "-----------------------------"
	echo "added to the PATH: $fftwdir/bin:$petscdir/bin"
	echo "added to the LD_LIBRARY_PATH: $openblasdir/lib:$scalapackdir/lib:$fftwdir/lib:$petscdir/lib"
	#	echo "To return to the older path execute /home/phc/bin/default.sh "
	echo "-----------------------------"
	echo "Module numericallibs loaded"
	echo "Added : openblas , scalapack, fftw(fastfourier), petsc"
	#	echo "EXECUTE sudo ldconfig"
	
fi