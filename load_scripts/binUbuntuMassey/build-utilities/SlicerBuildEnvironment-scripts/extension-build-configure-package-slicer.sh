#!/bin/bash
#From: https://github.com/Slicer/SlicerBuildEnvironment
ROOT_DIR=/tmp/SlicerDocker
DOCKER_IMAGE=buildenv-qt5-centos7

cd ${ROOT_DIR}

EXTENSION_NAME=BoneTextureExtension

# Download extension source
git clone git://github.com/Kitware/${EXTENSION_NAME} ${EXTENSION_NAME}

# Configure the extension
slicer-${DOCKER_IMAGE} cmake \
  -B${EXTENSION_NAME}-build -H${EXTENSION_NAME} \
  -GNinja \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DSlicer_DIR:PATH=/work/Slicer-build/Slicer-build


# Hint: /work is the working directory in the image, it corresponds to
#       the directory from which the script `slicer-${DOCKER_IMAGE}` is called.


# Build the extension
slicer-${DOCKER_IMAGE} cmake --build ${EXTENSION_NAME}-build

# Package the extension
slicer-${DOCKER_IMAGE} cmake --build ${EXTENSION_NAME}-build --target package
