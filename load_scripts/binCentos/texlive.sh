#!/bin/bash
#YOU HAVE TO EXECUTE THIS AS SOURCE TO HAVE EFFECT

if echo $texliveloaded |grep -q 'loaded'
then
    echo "texlive already loaded"
    # echo "pdflatex -output-format='pdf' -output-directory=../output -synctex=1 main.tex"
else
    export texliveloaded="loaded"
    export oldPATH=$PATH
    
    texlivehome=/usr/local/texlive/2013/bin/x86_64-linux
    export PATH=$texlivehome:$PATH
    
    echo "Module texlive loaded"
    # echo "pdflatex -output-format='pdf' -output-directory=../output -synctex=1 main.tex"
fi

