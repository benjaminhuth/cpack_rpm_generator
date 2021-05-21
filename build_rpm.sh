#!/bin/bash

RELEASE=1
GROUP="Development/Libraries"
CMAKE_GEN="Ninja"

if [[ $# != 4 ]]; then
    echo "Usage: $0 <name> <version> <path> <desc> (<group>)"
    exit 1
fi

# Check some programms
if ! command -v rpmbuild &> /dev/null; then
    echo "Error: 'rpmbuild' is required but not found. Please install the rpm build tools."
    exit 1
fi

if ! command -v cpack &> /dev/null; then
    echo "Error: 'cpack' is required but not found. Please install cmake."
    exit 1
fi

# Run cpack
ARCH="$(uname -m)"
PACKAGE_NAME="$1-$2-$RELEASE.$ARCH"
echo "SUMMARY:"
echo "  name:                        $PACKAGE_NAME:"
echo "  version:                     $2"
echo "  description:                 $4"
echo "  group:                       $GROUP"
echo "  based on build directory:    $3"
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

CPACK_RETURN_CODE=$?
    
echo ""
    
if [[ $CPACK_RETURN_CODE != 0 ]]; then
    echo "Error: cpack failed building '$PACKAGE_NAME'"
    exit 1
fi

echo "Building '$PACKAGE_NAME' seems to be successfull!"
