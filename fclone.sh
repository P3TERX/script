#!/usr/bin/env bash
#
# Copyright (c) 2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/script
# File name：fclone.sh
# Description: Install the latest version fclone
# Version: 1.1
#

set -o errexit
set -o pipefail
set -o nounset

if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

TMPFILE=/tmp/fclone.zip
CLDBIN=/usr/bin/fclone
OSARCH=$(uname -m)
case $OSARCH in
x86_64)
    BINTAG=linux-amd64
    ;;
i*86)
    BINTAG=linux-386
    ;;
arm64)
    BINTAG=linux-arm64
    ;;
arm*)
    BINTAG=linux-arm
    ;;
*)
    echo "unsupported OSARCH: $OSARCH"
    exit 1
    ;;
esac

DOWNLOAD_URL=$(wget -qO- https://api.github.com/repos/mawaya/rclone/releases/latest | grep browser_download_url | grep "$BINTAG" | cut -d'"' -f4)

wget -nv ${DOWNLOAD_URL} -O "${TMPFILE}"

unzip -jo "${TMPFILE}" -d "${CLDBIN%/*}" || busybox unzip -jo "${TMPFILE}" -d "${CLDBIN%/*}"
rm -vf "${TMPFILE}"
chmod +x "${CLDBIN}"

fclone version
