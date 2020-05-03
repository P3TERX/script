#!/usr/bin/env bash
#=================================================
# https://github.com/P3TERX/script
# File name: ctop.sh
# Description: Install the latest version ctop
# System Required: Debian/Ubuntu or other
# Version: 1.0
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
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

ARCH=$(uname -m)
[ $(command -v dpkg) ] &&
    dpkgARCH=$(dpkg --print-architecture | awk -F- '{ print $NF }')

echo -e "${INFO} Check CPU architecture ..."
if [[ $ARCH == "x86_64" || $dpkgARCH == "amd64" ]]; then
    ARCH="amd64"
elif [[ $ARCH == "aarch64" || $dpkgARCH == "arm64" ]]; then
    ARCH="arm64"
elif [[ $ARCH == "armv7l" || $dpkgARCH == "armhf" ]]; then
    ARCH="arm"
else
    echo -e "${ERROR} This architecture is not supported."
    exit 1
fi

echo -e "${INFO} Download ctop ..."
wget -nv -O- https://api.github.com/repos/bcicen/ctop/releases/latest |
    grep "browser_download_url.*linux-$ARCH\"" |
    cut -d '"' -f 4 |
    wget -nv -O ctop -i-

[ -s ctop ] && echo -e "${INFO} ctop download successful !" || {
    echo -e "${ERROR} Unable to download ctop, network failure or other error."
    exit 1
}

chmod +x ctop

if [[ $1 = "install" ]]; then
    echo -e "${INFO} Installing ctop ..."
    [ $EUID != 0 ] && {
        SUDO=sudo
        echo -e "${INFO} You may need to enter a password to authorize."
    }
    $SUDO mv -vf ctop /usr/local/bin && {
        echo -e "${INFO} ctop installed successfully !"
        ctop -v
    } || {
        echo -e "${ERROR} ctop installation failed !"
        exit 1
    }
else
    ./ctop -v
fi
