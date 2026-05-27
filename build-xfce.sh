#!/usr/bin/env bash

set -euo pipefail

EMACS_GIT_REPO="https://github.com/emacsmirror/emacs.git"
TARGET_EMACS_VERSION="30.2"
DOWNLOAD_DIR="${HOME}/projects/emacs-src/"
target_version_tag_name="emacs-${TARGET_EMACS_VERSION}"
install_prefix="/opt/${target_version_tag_name}"

if [ ! -d "$DOWNLOAD_DIR" ];
then
    mkdir -p "${DOWNLOAD_DIR}"
    cd "${DOWNLOAD_DIR}"
    git init
    git remote add origin "${EMACS_GIT_REPO}"
else
    cd "${DOWNLOAD_DIR}"
fi

git fetch --depth 1 origin tag "${target_version_tag_name}"
git checkout "tags/${target_version_tag_name}"

# WIP and untested:

# TODO detect gcc version, install correct gccjit lib, tree sitter etc

if [ -f Makefile ]; then
    make clean
fi

./autogen.sh

CFLAGS="-march=native -O2 -pipe -fno-finite-math-only" \
./configure \
  --prefix="${install_prefix}" \
  --with-modules \
  --with-x \
  --with-x-toolkit=lucid \
  --with-xft \
  --with-harfbuzz \
  --with-tree-sitter \
  --with-native-compilation=aot \
  --with-sqlite3 \
  --with-png \
  --with-jpeg \
  --with-gif \
  --with-webp \
  --with-rsvg \
  --without-tiff \
  --without-pgtk \
  --without-imagemagick \
  --without-compress-install \
  --without-gsettings \
  --without-gconf \
  --without-mailutils

make -j
sudo make install
