#!/bin/bash

. /root/config/package

export AS="as"
export AR="ar"
export NM="nm"
export LD="ld"

export AWK="awk"
export RANLIB="ranlib"
export OBJCOPY="objcopy"
export OBJDUMP="objdump"
export STRIP="strip"

export CC="gcc"
export CXX="g++"
export CPP="cpp"

if [[ "${PKG_MAKE_OPTS_TARGET}" =~ "-C ../" ]]; then
  PKG_BUILD="${PKG_BUILD}/build"
  mkdir -p $PKG_BUILD
fi

cd $PKG_BUILD

if [ "$(type -t pre_make_target)" = "function" ]; then
  pre_make_target
fi

PKG_BUILD_PATCH="/root/patches/${PACKAGE}"

if [ -f "${PKG_BUILD_PATCH}" ]; then
  . ${PKG_BUILD_PATCH}
fi

if [[ "${ARCH}" = "arm" ]]; then
  PKG_MAKE_OPTS_TARGET="${PKG_MAKE_OPTS_TARGET//platform=rpi3_64/platform=rpi3}"
  PKG_MAKE_OPTS_TARGET="${PKG_MAKE_OPTS_TARGET//platform=rpi4_64/platform=rpi4}"
fi

export LDFLAGS="-Wl,--as-needed ${TARGET_LDFLAGS}"
export CFLAGS="${TARGET_CFLAGS} -Wall -pipe ${PROJECT_CFLAGS}"
export CXXFLAGS="${CFLAGS} ${TARGET_CXXFLAGS}"
export CPPFLAGS="${CXXFLAGS} ${TARGET_CPPFLAGS}"

echo ""
echo "  Core      : ${PACKAGE}"
echo "  Project   : ${PROJECT}"
echo "  Device    : ${DEVICE}"
echo "  Arch      : ${ARCH}"
echo "  Features  : ${TARGET_FEATURES}"
echo ""
echo "  CFLAGS    : ${CFLAGS:-none}"
echo "  CXXFLAGS  : ${CXXFLAGS:-none}"
echo "  LDFLAGS   : ${LDFLAGS:-none}"
echo ""
echo "  TOOLCHAIN : ${PKG_TOOLCHAIN:-auto}"
echo "  MAKEOPTS  : ${PKG_MAKE_OPTS_TARGET:-none}"
echo "  CMAKEOTPS : ${PKG_CMAKE_OPTS_TARGET:-none}"
echo ""

if [ "$(type -t make_target)" = "function" ]; then
  make_target
elif [ "${PKG_TOOLCHAIN}" = "cmake" ]; then
  cmake $PKG_CMAKE_OPTS_TARGET . -Bbuild
  cmake --build build/ --target "${PACKAGE}_libretro" --config Release --parallel "${JOBS}"
elif [ "${PKG_TOOLCHAIN}" = "make" ]; then
  make $PKG_MAKE_OPTS_TARGET -j "${JOBS}"
else
  echo "Selected toolchain is not supported!"
  exit 1
fi

if [ "$(type -t post_make_target)" = "function" ]; then
  post_make_target
fi

if [ "$(type -t makeinstall_target)" = "function" ]; then
  makeinstall_target || true
fi

file_match="*libretro.so"
num_copied=$(find "${RESULT_DIR}" -type f -name "${file_match}" | wc -l)

if [ "$num_copied" -eq 0 ]; then
  mkdir -p "${RESULT_DIR}"
  find "${SOURCE_DIR}" -type f -name "${file_match}" -exec cp -v {} "${RESULT_DIR}" \;

  num_copied=$(find "${RESULT_DIR}" -type f -name "${file_match}" | wc -l)
fi

if [ "$num_copied" -eq 0 ]; then
  echo "Error: No libretro core files found!"
  exit 1
fi
