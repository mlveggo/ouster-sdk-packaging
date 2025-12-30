$ErrorActionPreference = "Stop"

if (-not $Env:OUSTER_VERSION) {
    throw "OUSTER_VERSION not set"
}

$VCPKG_ROOT = "C:/vcpkg"

git clone https://github.com/ouster-lidar/ouster-sdk.git
cd ouster-sdk
git fetch --tags
git checkout $Env:OUSTER_VERSION

New-Item -ItemType Directory -Force -Path ../stage | Out-Null

cmake -S . -B build `
  -DCMAKE_BUILD_TYPE=Release `
  -DBUILD_SHARED_LIBRARY=OFF `
  -DBUILD_EXAMPLES=OFF `
  -DBUILD_VIZ=OFF `
  -DBUILD_OSF=ON `
  -DBUILD_TESTING=OFF `
  -DBUILD_MAPPING=OFF `
  -DCMAKE_INSTALL_PREFIX=../stage `
  -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake"

cmake --build build --config Release
cmake --install build --config Release

Set-Content ../stage/version.txt $Env:OUSTER_VERSION
