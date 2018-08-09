#!/bin/bash

set -xeu
set -o pipefail

#From: https://github.com/Slicer/SlicerBuildEnvironment
ROOT_DIR=/tmp/SlicerDocker
DOCKER_IMAGE=buildenv-qt5-centos7
# August 5th 2018
Slicer_SHA=ea79c943d168f637cb3347bda199d47bbb111890
mkdir -p $ROOT_DIR

cd ${ROOT_DIR}

# Download sources: https://www.slicer.org/wiki/Documentation/Nightly/Developers/Build_Instructions#CHECKOUT_slicer_source_files
# svn co http://svn.slicer.org/Slicer4/branches/Slicer-4-8 Slicer -r 26813
if [[ ! -d Slicer ]]; then
  git clone https://github.com/Slicer/Slicer Slicer
fi
cd Slicer; git reset --hard ea79c943d168f637cb3347bda199d47bbb111890; cd ${ROOT_DIR}

# Download extensions:
# Hint: /work is the working directory in the image, it corresponds to
# the directory from which the script `slicer-${DOCKER_IMAGE}` is called.
########
EXTENSION_NAME=MeshToLabelMap
if [[ ! -d ${EXTENSION_NAME} ]]; then
  git clone https://github.com/NIRALUser/MeshToLabelMap ${EXTENSION_NAME}
fi
Slicer_EXTENSION_SOURCE_DIRS="/work/${EXTENSION_NAME}"
########
EXTENSION_NAME=BoneTextureExtension
if [[ ! -d ${EXTENSION_NAME} ]]; then
  git clone git://github.com/Kitware/${EXTENSION_NAME} ${EXTENSION_NAME}
fi
Slicer_EXTENSION_SOURCE_DIRS="${Slicer_EXTENSION_SOURCE_DIRS};/work/${EXTENSION_NAME}"
########
EXTENSION_NAME=CMFreg
if [[ ! -d ${EXTENSION_NAME} ]]; then
  git clone git://github.com/DCBIA-OrthoLab/${EXTENSION_NAME} ${EXTENSION_NAME}
fi
Slicer_EXTENSION_SOURCE_DIRS="${Slicer_EXTENSION_SOURCE_DIRS};/work/${EXTENSION_NAME}"
########
EXTENSION_NAME=EasyClip-Extension
if [[ ! -d ${EXTENSION_NAME} ]]; then
  # git clone git://github.com/DCBIA-OrthoLab/${EXTENSION_NAME} ${EXTENSION_NAME}
  # Load/Save clip planes failing in current master before PR is merged:
  # https://github.com/DCBIA-OrthoLab/EasyClip-Extension/pull/7
  git clone git://github.com/phcerdan/${EXTENSION_NAME} ${EXTENSION_NAME}
  cd ${EXTENSION_NAME}; git checkout fix_save_read_function; cd ${ROOT_DIR}
fi
Slicer_EXTENSION_SOURCE_DIRS="${Slicer_EXTENSION_SOURCE_DIRS};/work/${EXTENSION_NAME}"
########
EXTENSION_NAME=SlicerVolumeClip
if [[ ! -d ${EXTENSION_NAME} ]]; then
  git clone git://github.com/PerkLab/${EXTENSION_NAME} ${EXTENSION_NAME}
fi
Slicer_EXTENSION_SOURCE_DIRS="${Slicer_EXTENSION_SOURCE_DIRS};/work/${EXTENSION_NAME}"
########
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
