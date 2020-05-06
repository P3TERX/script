#!/usr/bin/env bash
#=================================================
# https://github.com/P3TERX/script
# File name: oh-my-tmux.sh
# Description: Install Oh My Tmux
# System Required: Debian/Ubuntu or other
# Version: 1.2
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

[ $(command -v git) ] || {
    echo -e "${ERROR} Git is not installed."
    exit 1
}

[ $(command -v tmux) ] || {
    echo -e "${ERROR} tmux is not installed."
    exit 1
}

echo -e "${INFO} Installation Oh My Tmux ..."
[[ -e $HOME/.tmux.conf && ! -L $HOME/.tmux.conf ]] && mv $HOME/.tmux.conf $HOME/.tmux.conf.bak
rm -rf $HOME/.tmux
git clone -q https://github.com/gpakosz/.tmux.git $HOME/.tmux
ln -sf $HOME/.tmux/.tmux.conf $HOME/.tmux.conf
[ -e $HOME/.tmux.conf.local ] || cp $HOME/.tmux/.tmux.conf.local $HOME

[[ -e $HOME/.tmux && -e $HOME/.tmux.conf && -e $HOME/.tmux.conf.local ]] &&
    echo -e "${INFO} Oh My Tmux successful installation !" || {
    echo -e "${ERROR} Oh My Tmux installation failed !"
    exit 1
}
exit 0
