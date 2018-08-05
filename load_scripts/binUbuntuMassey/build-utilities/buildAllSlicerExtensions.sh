#!/bin/bash

# export EXTENSIONS_DIR="$(dirname "$(readlink -f "$0")")"
# export EXTENSIONS_DIR="$(dirname -f "$0")"
# This has to be called with ./buildAllSlicerExntesions.sh (same folder)
export EXTENSIONS_DIR="$(pwd)"
echo "Base Extension dir: ${EXTENSIONS_DIR}"
declare -a extensions=(
"AnglePlanes-Extension"
"BoneTextureExtension"
"CMFreg-SurfaceRegistration"
"EasyClip-Extension"
"MeshToLabelMap"
"SRepExtension"
"VolumeClip"
)

for i in "${extensions[@]}"
do
    echo "------------------------------"
    echo "Start building extension: ${i}"
    cd ${i}/build;
    ninja
    cd ${EXTENSIONS_DIR}
    echo "Finish building extension ${i}"
    echo "------------------------------"
done

echo "Finish"
