#!/usr/bin/env bash
#=================================================
# https://github.com/P3TERX/script
# File name: gotop.sh
# Description: Install gotop
# System Required: GNU/Linux
# Version: 1.1
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================

Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"
INFO="[${Green_font_prefix}INFO${Font_color_suffix}]"
ERROR="[${Red_font_prefix}ERROR${Font_color_suffix}]"

echo -e "${INFO} Download gotop ..."
curl -fsSL https://raw.githubusercontent.com/cjbassi/gotop/master/scripts/download.sh | bash
[ -s gotop ] && echo -e "${INFO} gotop download successful !" || {
    echo -e "${ERROR} Unable to download gotop, network failure or other error."
    exit 1
}

echo -e "${INFO} Installation gotop ..."
[ $EUID != 0 ] && {
    SUDO=sudo
    echo -e "${INFO} You may need to enter a password to authorize."
}
$SUDO mv -vf gotop /usr/local/bin
$SUDO chmod +x /usr/local/bin/gotop && echo -e "${INFO} gotop successful installation !" || {
    echo -e "${ERROR} gotop installation failed !"
    exit 1
}
exit 0
