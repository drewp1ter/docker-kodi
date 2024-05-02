#!/usr/bin/env sh

set -e

cmake ./../xbmc \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DENABLE_INTERNAL_FLATBUFFERS=ON \
      -DENABLE_INTERNAL_WAYLAND_PROTOCOLS=ON \
      -DENABLE_INTERNAL_WAYLANDPP=ON \
      -DENABLE_INTERNAL_DAV1D=ON \
      -DCORE_PLATFORM_NAME=x11 \
      -DAPP_RENDER_SYSTEM=gl \
      -DX11_RENDER_SYSTEM=gl \
      -DCPACK_GENERATOR=DEB

cmake --build . -- VERBOSE=1 -j$(getconf _NPROCESSORS_ONLN)

cpack --config ./CPackConfig.cmake