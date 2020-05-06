#!/usr/bin/env bash
#==================================================================
# https://github.com/P3TERX/script
# File name: oh-my-zsh.sh
# Description: Install a simple Oh-My-Zsh environment using Antigen
# System Required: GNU/Linux
# Version: 1.1
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#==================================================================
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

[ $(command -v zsh) ] || {
    echo -e "${ERROR} Zsh is not installed."
    exit 1
}

echo -e "${INFO} Installation Antigen ..."
rm -rf $HOME/.antigen
mkdir -p $HOME/.antigen
curl -L git.io/antigen >$HOME/.antigen/antigen.zsh
curl -fsSL https://raw.githubusercontent.com/P3TERX/dotfiles/master/.zshrc >$HOME/.zshrc

echo -e "${INFO} Installation Oh My Zsh ..."
zsh $HOME/.zshrc
