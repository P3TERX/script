#!/bin/sh
#===========================================
# https://github.com/P3TERX/script
# File name: github-actions-trigger.sh
# Description: GitHub Actions trigger script
# System Required: GNU/Linux
# Version: 1.0
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===========================================

ACTIONS_TRIGGER_TOKEN=$1
REPO_NAME=$2
TRIGGER_KEYWORDS=${3:-'Manual trigger'}

curl -i -X POST https://api.github.com/repos/$REPO_NAME/dispatches \
    -H "Accept: application/vnd.github.everest-preview+json" \
    -H "Authorization: token $ACTIONS_TRIGGER_TOKEN" \
    --data "{\"event_type\": \"$TRIGGER_KEYWORDS\"}"
