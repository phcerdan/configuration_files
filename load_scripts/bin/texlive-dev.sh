#!/bin/bash

if echo $texlive_dev_loaded |grep -q 'loaded'
then
    echo "texlive already loaded"
else
    export texlive_dev_loaded="loaded"
    export oldPATH=$PATH
    texlivehome=/home/phc/devtoolset/texlive/2014/bin/x86_64-linux
    export PATH=$texlivehome:$PATH
    echo "Module texlive loaded"
    # echo "pdflatex -output-format='pdf' -output-directory=../output -synctex=1 main.tex"
fi
