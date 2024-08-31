#!/bin/bash

. /etc/os-release

# Add the Deb-Multimedia repository to get FFmpeg 6 on Debian Bookworm
if [ "${VERSION_CODENAME}" = "bookworm" ]; then
  echo "deb https://www.deb-multimedia.org ${VERSION_CODENAME} main" \
    > /etc/apt/sources.list.d/deb-multimedia.list

  apt-get update -oAcquire::AllowInsecureRepositories=true
  apt-get install --allow-unauthenticated -yq deb-multimedia-keyring
fi
