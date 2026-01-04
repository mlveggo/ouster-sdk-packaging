# Ouster SDK Packaging

This repository builds and publishes precompiled Ouster SDK binaries
for Linux, macOS, and Windows.

### Versioning

- Release versions exactly match upstream `ouster-sdk` tags.
- Example: `v0.16.0`

### Artifacts

Each release contains:
- headers
- static libraries
- CMake config files

### Supported Platforms

- Linux x86_64
- macOS arm64
- Windows MSVC x64

## Using the Prebuilt Ouster SDK in a CMake Project

The release packages are intended to be consumed directly from CMake, without rebuilding the SDK.

---

## Package Layout

After extracting a release archive, the directory structure is:

```
ouster/
  include/
  lib/
  cmake/
  version.txt
```

The top-level folder name (`ouster`) is **stable across versions**.
The SDK version used to build the package is recorded in `version.txt`.

---

## Basic Usage with CMake

### 1. Extract the SDK

Extract the release archive into your project or a dependency directory, for example:

```
third_party/ouster/
```

Resulting layout:

```
third_party/ouster/include
third_party/ouster/lib
third_party/ouster/cmake
third_party/ouster/version.txt
```

---

### 2. Point CMake to the SDK

Add the SDK location to `CMAKE_PREFIX_PATH` **before** calling `find_package`:

```cmake
set(OUSTER_SDK_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/third_party/ouster")
list(APPEND CMAKE_PREFIX_PATH "${OUSTER_SDK_ROOT}")
```

Alternatively, pass this on the command line:

```bash
cmake -DCMAKE_PREFIX_PATH=/path/to/ouster ..
```

---

### 3. Find and Link the SDK

```cmake
find_package(OusterSDK REQUIRED)

add_executable(my_app main.cpp)

target_link_libraries(my_app
  PRIVATE
    OusterSDK::ouster_client
    OusterSDK::ouster_osf
)
```

This automatically configures:

- include directories
- link libraries
- transitive dependencies

---

## Verifying the SDK Version (Optional)

The SDK version used to build the package is stored in:

```
ouster/version.txt
```

You may read and print this in CMake for diagnostics:

```cmake
file(READ "${OUSTER_SDK_ROOT}/version.txt" OUSTER_SDK_VERSION)
string(STRIP "${OUSTER_SDK_VERSION}" OUSTER_SDK_VERSION)
message(STATUS "Using Ouster SDK ${OUSTER_SDK_VERSION}")
```

---

## Platform Notes

### Linux

- The SDK links dynamically against system libraries (e.g. `libcurl`, `libpcap`, `libzip`)
- Ensure required runtime dependencies are installed on the target system

### Windows

- Built with MSVC in Release mode
- Consumers must use a compatible MSVC toolchain
- Debug libraries are not provided

### macOS

- macOS binaries may not be provided depending on release availability

---

## Minimal Example

```cmake
cmake_minimum_required(VERSION 3.20)
project(example LANGUAGES CXX)

set(OUSTER_SDK_ROOT "${CMAKE_SOURCE_DIR}/third_party/ouster")
list(APPEND CMAKE_PREFIX_PATH "${OUSTER_SDK_ROOT}")

find_package(OusterSDK REQUIRED)

add_executable(example main.cpp)
target_link_libraries(example PRIVATE OusterSDK::ouster_client)
```

---

## Updating the SDK Version

To update the SDK version used by your project:

1. Remove the existing `ouster/` directory
2. Extract the new release archive
3. Reconfigure your project

No CMake changes are required as long as the top-level folder name remains `ouster`.
