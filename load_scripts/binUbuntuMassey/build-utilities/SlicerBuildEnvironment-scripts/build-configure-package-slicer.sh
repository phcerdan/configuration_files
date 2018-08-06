#!/bin/bash
#From: https://github.com/Slicer/SlicerBuildEnvironment
ROOT_DIR=/tmp/SlicerDocker
DOCKER_IMAGE=buildenv-qt5-centos7
# August 5th 2018
Slicer_SHA=ea79c943d168f637cb3347bda199d47bbb111890
mkdir -p $ROOT_DIR

cd ${ROOT_DIR}

# Download sources: https://www.slicer.org/wiki/Documentation/Nightly/Developers/Build_Instructions#CHECKOUT_slicer_source_files
# svn co http://svn.slicer.org/Slicer4/branches/Slicer-4-8 Slicer -r 26813
git clone https://github.com/Slicer/Slicer Slicer
cd Slicer; git reset --hard ea79c943d168f637cb3347bda199d47bbb111890; cd ${ROOT_DIR}

# Download extensions:
# Hint: /work is the working directory in the image, it corresponds to
# the directory from which the script `slicer-${DOCKER_IMAGE}` is called.
EXTENSION_NAME=MeshToLabelMap
git clone https://github.com/NIRALUser/MeshToLabelMap ${EXTENSION_NAME}
Slicer_EXTENSION_SOURCE_DIRS="/work/${EXTENSION_NAME}"

EXTENSION_NAME=BoneTextureExtension
git clone git://github.com/Kitware/${EXTENSION_NAME} ${EXTENSION_NAME}
Slicer_EXTENSION_SOURCE_DIRS="${Slicer_EXTENSION_SOURCE_DIRS};/work/${EXTENSION_NAME}"
echo "Slicer_EXTENSION_SOURCE_DIRS: ${Slicer_EXTENSION_SOURCE_DIRS}"

# Download corresponding build environment and generate convenience script
docker run --rm slicer/${DOCKER_IMAGE} > ~/bin/slicer-${DOCKER_IMAGE}
chmod u+x ~/bin/slicer-${DOCKER_IMAGE}

# Configure Slicer
slicer-${DOCKER_IMAGE} cmake \
  -BSlicer-build -HSlicer \
  -GNinja \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DSlicer_USE_SimpleITK:BOOL=OFF \
  -DBUILD_TESTING:BOOL=OFF \
  -DSlicer_EXTENSION_SOURCE_DIRS:STRING=${Slicer_EXTENSION_SOURCE_DIRS} \
  -DSlicer_VTK_VERSION_MAJOR:STRING=9 \
  -DSlicer_REQUIRED_QT_VERSION:STRING=5

# Qt5_DIR will be populated, because it is already in the system path.

# Build Slicer
slicer-${DOCKER_IMAGE} cmake --build Slicer-build

# Package Slicer
slicer-${DOCKER_IMAGE} cmake --build Slicer-build/Slicer-build --target package
