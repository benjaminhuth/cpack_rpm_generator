#!/bin/bash

RELEASE=1
GROUP="Development/Libraries"
CMAKE_GEN="Ninja"

if [[ $# != 4 ]]; then
    echo "Usage: $0 <name> <version> <path> <desc> (<group>)"
    exit 1
fi

ARCH="$(uname -m)"
PACKAGE_NAME="$1-$2-$RELEASE.$ARCH"
echo "create RPM $PACKAGE_NAME:"
echo "-version: $2"
echo "-description: $4"
echo "-group: $GROUP"
echo "-based on build directory: $3"
echo ""

cpack \
    -G "RPM" \
    -P "$1" \
    -D CPACK_PACKAGE_VERSION=$2 \
    -D CPACK_INSTALL_CMAKE_PROJECTS="$3;$1;ALL;/" \
    -D CPACK_PACKAGE_FILE_NAME="$PACKAGE_NAME" \
    -D CPACK_PACKAGE_DESCRIPTION="$4" \
    -D CPACK_CMAKE_GENERATOR="$CMAKE_GEN" \
    -D CPACK_RPM_PACKAGE_GROUP="$GROUP" \
    -D CPACK_RPM_EXCLUDE_FROM_AUTO_FILELIST_ADDITION="/usr/lib64/cmake"
    
echo ""
echo "building RPM $PACKAGE_NAME seems to be successfull!"
