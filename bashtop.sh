#!/usr/bin/env bash
#=================================================
# https://github.com/P3TERX/script
# File name: bashtop.sh
# Description: Install the latest version bashtop
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

echo -e "${INFO} Download bashtop ..."
curl -O https://raw.githubusercontent.com/aristocratos/bashtop/master/bashtop

[ -s bashtop ] && echo -e "${INFO} bashtop download successful !" || {
    echo -e "${ERROR} Unable to download bashtop, network failure or other error."
    exit 1
}

chmod +x bashtop

if [[ $1 = "install" ]]; then
    echo -e "${INFO} Installing bashtop ..."
    [ $EUID != 0 ] && {
        SUDO=sudo
        echo -e "${INFO} You may need to enter a password to authorize."
    }
    $SUDO mv -vf bashtop /usr/local/bin && {
        echo -e "${INFO} bashtop installed successfully !"
    } || {
        echo -e "${ERROR} bashtop installation failed !"
        exit 1
    }
fi
