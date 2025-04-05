#!/bin/sh

mkdir build
cd build

# DCMAKE_FIND_PACKAGE_PREFER_CONFIG is passed to
# try to avoid weird mix of FindProtobuf and protobuf-config targets
cmake ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True \
      -DBUILD_SHARED_LIBS=ON \
      -DBUILD_TESTING=OFF \
      -DCMAKE_FIND_PACKAGE_PREFER_CONFIG:BOOL=ON \
      ..

cmake --build . --config Release
cmake --build . --config Release --target install
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
ctest --output-on-failure -C Release
fi
