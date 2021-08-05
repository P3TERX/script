#!/usr/bin/env bash
#
# https://github.com/P3TERX/script
# File name: hostname.sh
# Description: Hostname modify script
# System Required: GNU/Linux
# Version: 1.0
#
# MIT License
#
# Copyright (c) 2021 P3TERX <https://p3terx.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

FontColor_Red="\033[31m"
FontColor_Green="\033[32m"
FontColor_Purple="\033[35m"
FontColor_Suffix="\033[0m"

log() {
    local LEVEL="$1"
    local MSG="$2"
    case "${LEVEL}" in
    INFO)
        local LEVEL="[${FontColor_Green}${LEVEL}${FontColor_Suffix}]"
        local MSG="${LEVEL} ${MSG}"
        ;;
    ERROR)
        local LEVEL="[${FontColor_Red}${LEVEL}${FontColor_Suffix}]"
        local MSG="${LEVEL} ${MSG}"
        ;;
    *) ;;
    esac
    echo -e "${MSG}"
}

if [[ $(uname -s) != Linux ]]; then
    log ERROR "This operating system is not supported."
    exit 1
fi

if [[ $(id -u) != 0 ]]; then
    log ERROR "This script must be run as root."
    exit 1
fi

HostName="$1"
hosts_file='/etc/hosts'

if [[ $(grep "^127.0.1.1.*${HostName}" ${hosts_file}) ]]; then
    log INFO "The hostname(${FontColor_Purple}${HostName}${FontColor_Suffix}) already exists in the hosts file."
else
    log INFO "Add hostname(${FontColor_Purple}${HostName}${FontColor_Suffix}) to hosts file."
    if [[ $(grep '^127.0.1.1' ${hosts_file}) ]]; then
        sed -i "s@^\(127.0.1.1.*\)@\1\t${HostName}@" ${hosts_file}
    else
        sed -i "/localhost/a 127.0.1.1\t${HostName}" ${hosts_file}
    fi
fi

log INFO "Setting hostname(${FontColor_Purple}${HostName}${FontColor_Suffix})..."
hostnamectl set-hostname ${HostName}
if [[ $? = 0 ]]; then
    log INFO "Done."
else
    log ERROR "Unable to set hostname!"
fi
