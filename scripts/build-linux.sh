#!/usr/bin/env bash
set -euo pipefail

: "${OUSTER_VERSION:?OUSTER_VERSION not set}"

STAGE_DIR="$PWD/stage"

git clone https://github.com/ouster-lidar/ouster-sdk.git
cd ouster-sdk
git checkout "${OUSTER_VERSION}"

cmake -S . -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_OSF=ON \
  -DBUILD_SHARED_LIBRARY=OFF \
  -DBUILD_EXAMPLES=OFF \
  -DBUILD_VIZ=OFF \
  -DCMAKE_INSTALL_PREFIX="${STAGE_DIR}"

cmake --build build -- -j$(nproc)
cmake --install build

echo "${OUSTER_VERSION}" > "${STAGE_DIR}/version.txt"
