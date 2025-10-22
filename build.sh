#!/usr/bin/env sh

set -euo pipefail

EMACS_GIT_REPO="https://github.com/emacsmirror/emacs.git"
TARGET_EMACS_VERSION="30.2"
DOWNLOAD_DIR="${HOME}/projects/emacs-src/"

if [ ! -d "$DOWNLOAD_DIR" ];
then
    mkdir -p "${DOWNLOAD_DIR}"
    cd ${DOWNLOAD_DIR}
    git init
    git remote add origin ${EMACS_GIT_REPO}
else
    cd ${DOWNLOAD_DIR}
fi

target_version_tag_name="emacs-${TARGET_EMACS_VERSION}"
git fetch --depth 1 origin tag "${target_version_tag_name}"
git checkout "tags/${target_version_tag_name}"

# WIP and untested:
./configure.sh
./autogen.sh \
    CFLAGS="-march=native -O3 -pipe -fno-finite-math-only" \
    --with-modules \
    --with-x-toolkit=lucid \
    --with-xft \
    --with-harfbuzz \
    --with-xaw3d \
    --with-png --with-jpeg --with-tiff --with-gif --with-webp --with-rsvg \
    --with-imagemagick \
    --with-tree-sitter \
    --with-native-compilation=aot \
    --without-compress-install \
    --without-toolkit-scroll-bars \
    --without-gsettings \
    --without-gconf \
    --without-mailutils \
    --without-sound
