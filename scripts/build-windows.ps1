$ErrorActionPreference = "Stop"

if (-not $Env:OUSTER_VERSION) {
    throw "OUSTER_VERSION not set"
}

git clone https://github.com/ouster-lidar/ouster-sdk.git
cd ouster-sdk
git checkout $Env:OUSTER_VERSION

cmake -S . -B build `
  -DCMAKE_BUILD_TYPE=Release `
  -DBUILD_SHARED_LIBRARY=OFF `
  -DBUILD_EXAMPLES=OFF `
  -DBUILD_VIZ=OFF `
  -DCMAKE_INSTALL_PREFIX=../stage

cmake --build build --config Release
cmake --install build --config Release

Set-Content ../stage/version.txt $Env:OUSTER_VERSION
