#!/bin/bash

. /root/config/options

cd $LAKKA_DIR
./libretro_update.sh --packages ${PACKAGE}
cd $WORKDIR

. ${LAKKA_DIR}/config/functions
. ${PACKAGE_DIR}/package.mk

mkdir -p "${PACKAGE}"

git config --global init.defaultBranch main
git config --global advice.detachedHead false

git -C "${PACKAGE}" init
git -C "${PACKAGE}" remote add origin ${PKG_URL}

git -C "${PACKAGE}" fetch --depth 1 origin ${PKG_VERSION}
git -C "${PACKAGE}" checkout FETCH_HEAD

if [ "${GET_SKIP_SUBMODULE}" != "yes" ]; then
  git -C "${PACKAGE}" submodule update --init --recursive --depth 1
fi

for patch_file in ${PACKAGE_DIR}/patches/*.patch; do
  [ -e "$patch_file" ] || continue
  echo "Applying patch: $patch_file"
  patch -d "${PACKAGE}" -p1 < "$patch_file"
done

if [ "$(type -t post_patch)" = "function" ]; then
  post_patch
fi
