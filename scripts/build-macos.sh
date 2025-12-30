#!/usr/bin/env bash
set -euo pipefail

: "${OUSTER_VERSION:?OUSTER_VERSION not set}"

STAGE_DIR="$PWD/stage"

git clone https://github.com/ouster-lidar/ouster-sdk.git
cd ouster-sdk
git checkout "${OUSTER_VERSION}"

mkdir -p "$STAGE_DIR"

export CMAKE_PREFIX_PATH="/opt/homebrew/opt/eigen@3:${CMAKE_PREFIX_PATH}"

cmake -S . -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBRARY=OFF \
  -DBUILD_EXAMPLES=OFF \
  -DBUILD_TESTING=OFF \
  -DBUILD_VIZ=OFF \
  -DBUILD_OSF=ON \
  -DBUILD_MAPPING=OFF \
  -DCMAKE_INSTALL_PREFIX="${STAGE_DIR}"

cmake --build build -- -j$(sysctl -n hw.ncpu)
cmake --install build
