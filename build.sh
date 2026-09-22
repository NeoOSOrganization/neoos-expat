#!/bin/bash
set -e
PREFIX="${PREFIX:-$(pwd)/build-output}"
BUILD_TMP="${BUILD_TMP:-$(pwd)/build-tmp}"
mkdir -p "$PREFIX"
rm -rf "$BUILD_TMP"
cmake -S upstream/expat -B "$BUILD_TMP" \
    -DCMAKE_TOOLCHAIN_FILE="$(pwd)/toolchain.cmake" \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DEXPAT_BUILD_TESTS=OFF -DEXPAT_BUILD_EXAMPLES=OFF \
    -DEXPAT_BUILD_TOOLS=OFF -DEXPAT_SHARED_LIBS=OFF
cmake --build "$BUILD_TMP" -j"$(nproc)"
cmake --install "$BUILD_TMP"
