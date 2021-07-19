#!/usr/bin/env bash
#
# Copyright (c) 2020-2021 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/script
# File name: nali.sh
# Description: Install latest version Nali
# System Required: GNU/Linux
# Version: 1.2
#

set -o errexit
set -o errtrace
set -o pipefail

Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"
INFO="[${Green_font_prefix}INFO${Font_color_suffix}]"
ERROR="[${Red_font_prefix}ERROR${Font_color_suffix}]"

PROJECT_NAME='Nali'
GH_API_URL='https://api.github.com/repos/zu1k/nali/releases/latest'
BIN_DIR='/usr/local/bin'
BIN_NAME='nali'
BIN_FILE="${BIN_DIR}/${BIN_NAME}"

if [[ $(uname -s) != Linux ]]; then
    echo -e "${ERROR} This operating system is not supported."
    exit 1
fi

if [[ $(id -u) != 0 ]]; then
    echo -e "${ERROR} This script must be run as root."
    exit 1
fi

echo -e "${INFO} Get CPU architecture ..."
if [[ $(command -v apk) ]]; then
    PKGT='(apk)'
    OS_ARCH=$(apk --print-arch)
elif [[ $(command -v dpkg) ]]; then
    PKGT='(dpkg)'
    OS_ARCH=$(dpkg --print-architecture | awk -F- '{ print $NF }')
else
    OS_ARCH=$(uname -m)
fi
case ${OS_ARCH} in
*86)
    FILE_KEYWORD='linux-386'
    ;;
x86_64 | amd64)
    FILE_KEYWORD='linux-amd64'
    ;;
aarch64 | arm64)
    FILE_KEYWORD='linux-armv8'
    ;;
arm*)
    FILE_KEYWORD='linux-armv7'
    ;;
*)
    echo -e "${ERROR} Unsupported architecture: ${OS_ARCH} ${PKGT}"
    exit 1
    ;;
esac
echo -e "${INFO} Architecture: ${OS_ARCH} ${PKGT}"

echo -e "${INFO} Get ${PROJECT_NAME} download URL ..."
DOWNLOAD_URL=$(curl -fsSL ${GH_API_URL} | grep 'browser_download_url.*.gz"' | cut -d'"' -f4 | grep "${FILE_KEYWORD}")
echo -e "${INFO} Download URL: ${DOWNLOAD_URL}"

echo -e "${INFO} Installing ${PROJECT_NAME} ..."
curl -L "${DOWNLOAD_URL}" | gzip -d > ${BIN_FILE}
chmod +x ${BIN_FILE}
if [[ ! $(echo ${PATH} | grep ${BIN_DIR}) ]]; then
    ln -sf ${BIN_FILE} /usr/bin/${BIN_NAME}
fi
if [[ -s ${BIN_FILE} && $(${BIN_NAME} -h) ]]; then
    echo -e "${INFO} Done."
else
    echo -e "${ERROR} ${PROJECT_NAME} installation failed !"
    exit 1
fi
