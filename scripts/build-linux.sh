#!/usr/bin/env bash
set -euo pipefail

: "${OUSTER_VERSION:?OUSTER_VERSION not set}"

STAGE_DIR="$PWD/ouster"

git clone https://github.com/ouster-lidar/ouster-sdk.git
cd ouster-sdk
git fetch --tags
git checkout "${OUSTER_VERSION}"

mkdir -p "$STAGE_DIR"

cmake -S . -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=OFF \
  -DBUILD_SHARED_LIBRARY=OFF \
  -DBUILD_OSF=ON \
  -DBUILD_EXAMPLES=OFF \
  -DBUILD_VIZ=OFF \
  -DBUILD_TESTING=OFF \
  -DBUILD_MAPPING=OFF \
  -DCMAKE_INSTALL_PREFIX="$STAGE_DIR"

cmake --build build -- -j$(nproc)
cmake --install build

echo "${OUSTER_VERSION}" > "${STAGE_DIR}/version.txt"
