#!/usr/bin/env bash
#
# Copyright (c) 2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/script
# File name: tmate.sh
# Description: Install the latest version tmate
# System Required: Debian/Ubuntu or other
# Version: 1.3
#

[ $(uname) != Linux ] && {
    echo -e "This operating system is not supported."
    exit 1
}

Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"
INFO="[${Green_font_prefix}INFO${Font_color_suffix}]"
ERROR="[${Red_font_prefix}ERROR${Font_color_suffix}]"

[ $EUID != 0 ] && {
    SUDO=sudo
    echo -e "${INFO} You may need to enter a password to authorize."
}
$SUDO echo || exit 1

ARCH=$(uname -m)
[ $(command -v dpkg) ] &&
    dpkgARCH=$(dpkg --print-architecture | awk -F- '{ print $NF }')

echo -e "${INFO} Check the architecture ..."
if [[ $ARCH == i*86 || $dpkgARCH == i*86 ]]; then
    ARCH="i386"
elif [[ $ARCH == "x86_64" || $dpkgARCH == "amd64" ]]; then
    ARCH="amd64"
elif [[ $ARCH == "aarch64" || $dpkgARCH == "arm64" ]]; then
    ARCH="arm64v8"
elif [[ $ARCH == "armv7l" || $dpkgARCH == "armhf" ]]; then
    ARCH="arm32v7"
else
    echo -e "${ERROR} This architecture is not supported."
    exit 1
fi

echo -e "${INFO} Check the version of tmate ..."
tmate_ver=$(curl -fsSL https://api.github.com/repos/tmate-io/tmate/releases | grep -o '"tag_name": ".*"' | head -n 1 | sed 's/"//g;s/v//g' | sed 's/tag_name: //g')
[ -z $tmate_ver ] && {
    echo -e "${ERROR} Unable to check the version, network failure or API error."
    exit 1
}
[ $(command -v tmate) ] && {
    [[ $(tmate -V) != "tmate $tmate_ver" ]] && {
        echo -e "${INFO} Uninstall the old version ..."
        $SUDO rm -rf $(command -v tmate)
    } || {
        echo -e "${INFO} The latest version is installed."
        exit 0
    }
}
tmate_name="tmate-${tmate_ver}-static-linux-${ARCH}"
echo -e "${INFO} Download tmate ..."
curl -fsSL "https://github.com/tmate-io/tmate/releases/download/${tmate_ver}/${tmate_name}.tar.xz" | tar Jxf - --strip-components=1

[ -s tmate ] && echo -e "${INFO} tmate download successful !" || {
    echo -e "${ERROR} Unable to download tmate, network failure or other error."
    exit 1
}

echo -e "${INFO} Installation tmate ..."
$SUDO mv -f tmate /usr/local/bin && echo -e "${INFO} tmate successful installation !" || {
    echo -e "${ERROR} tmate installation failed !"
    exit 1
}
exit 0
