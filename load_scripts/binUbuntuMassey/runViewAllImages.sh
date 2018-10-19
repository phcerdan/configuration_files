#!/bin/bash

for arg in "$@"; do
    filename=$(basename -- "$arg")
    extension="${filename##*.}"
    filename="${filename%.*}"
    ~/repository_local/ITKfilters/build/runViewImage "$arg" "$filename" &
done;

