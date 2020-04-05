#!/usr/bin/env bash
#=================================================
# https://github.com/P3TERX/script
# File name: ffsend.sh
# Description: Install the latest version ffsend
# System Required: Debian/Ubuntu or other
# Version: 1.1
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
if [[ ${ARCH} != "x86_64" ]]; then
    echo -e "${ERROR} This architecture is not supported."
    exit 1
fi

echo -e "${INFO} Download ffsend ..."
wget -nv -O- https://api.github.com/repos/timvisee/ffsend/releases/latest |
    grep "browser_download_url.*linux-x64-static\"" |
    cut -d '"' -f 4 |
    wget -nv -O ffsend -i-

[ -s ffsend ] && echo -e "${INFO} ffsend download successful !" || {
    echo -e "${ERROR} Unable to download ffsend, network failure or other error."
    exit 1
}

chmod +x ffsend

if [[ $1 = "install" ]]; then
    echo -e "${INFO} Install ffsend ..."
    [ $EUID != 0 ] && {
        SUDO=sudo
        echo -e "${INFO} You may need to enter a password to authorize."
    }
    $SUDO mv -vf ffsend /usr/local/bin && {
        echo -e "${INFO} ffsend successful installation !"
        ffsend --version
    } || {
        echo -e "${ERROR} ffsend installation failed !"
        exit 1
    }
else
    ./ffsend --version
fi
