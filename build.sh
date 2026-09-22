#!/bin/bash
set -e
PREFIX="${PREFIX:-$(pwd)/build-output}"
BUILD_TMP="${BUILD_TMP:-$(pwd)/build-tmp}"
mkdir -p "$PREFIX"
rm -rf "$BUILD_TMP"
# -fPIC: this static lib gets linked directly into libEGL.so (a real
# shared object, neoos-mesa sub-project 2) -- without it, ld fails
# with "relocation R_X86_64_32S against `.rodata' can not be used when
# making a shared object". Sub-project 1 never hit this because
# nothing shared-object linked libexpat.a until EGL was enabled.
cmake -S upstream/expat -B "$BUILD_TMP" \
    -DCMAKE_TOOLCHAIN_FILE="$(pwd)/toolchain.cmake" \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DEXPAT_BUILD_TESTS=OFF -DEXPAT_BUILD_EXAMPLES=OFF \
    -DEXPAT_BUILD_TOOLS=OFF -DEXPAT_SHARED_LIBS=OFF
cmake --build "$BUILD_TMP" -j"$(nproc)"
cmake --install "$BUILD_TMP"
