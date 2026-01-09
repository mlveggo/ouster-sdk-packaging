$ErrorActionPreference = "Stop"

if (-not $Env:OUSTER_VERSION) {
    throw "OUSTER_VERSION not set"
}

$VCPKG_ROOT = "C:/vcpkg"
$STAGE_DIR="$PWD/ouster"

git clone https://github.com/ouster-lidar/ouster-sdk.git
Set-Location ouster-sdk
git fetch --tags
git checkout $Env:OUSTER_VERSION

New-Item -ItemType Directory -Force -Path "$STAGE_DIR" | Out-Null
cmake -S . -B build `
  -DCMAKE_BUILD_TYPE=Release `
  -DVCPKG_TARGET_TRIPLET=x64-windows-static `
  -DBUILD_SHARED_LIBS=OFF `
  -DBUILD_SHARED_LIBRARY=OFF `
  -DBUILD_EXAMPLES=OFF `
  -DBUILD_TESTING=OFF `
  -DBUILD_VIZ=OFF `
  -DBUILD_OSF=ON `
  -DBUILD_MAPPING=OFF `
  -DCMAKE_INSTALL_PREFIX="$STAGE_DIR" `
  -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake"

cmake --build build --config Release
cmake --install build --config Release

Set-Content "$STAGE_DIR/version.txt" $Env:OUSTER_VERSION
