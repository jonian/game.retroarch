#!/bin/bash

. /root/config/options

GIT_SOURCE="https://github.com/LibreELEC/LibreELEC.tv.git"
GIT_BRANCH="master"

case $LIBREELEC in
  9)
    GIT_BRANCH="libreelec-9.2"
    ;;
  10|11|12)
    GIT_BRANCH="libreelec-${LIBREELEC}.0"
    ;;
  13)
    GIT_BRANCH="master"
    ;;
  *)
    echo "LibreELEC v${LIBREELEC} is not supported!"
    exit 1
    ;;
esac

mkdir -p "${LE_DIR}"

git config --global init.defaultBranch main
git config --global advice.detachedHead false

git -C "${LE_DIR}" init
git -C "${LE_DIR}" remote add origin ${GIT_SOURCE}

git -C "${LE_DIR}" fetch --depth 1 origin ${GIT_BRANCH}
git -C "${LE_DIR}" checkout FETCH_HEAD
