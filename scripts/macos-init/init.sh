#!/usr/bin/env bash

# -----------------------------------------------------------------------------

cClear="\033[0m"

cGreenBold="\033[1;32m"
cGreen="\033[32m"
cGreenBrightBold="\033[1;92m"
cGreenBright="\033[92m"

cYellowBold="\033[1;33m"
cYellow="\033[33m"
cYellowBrightBold="\033[1;93m"
cYellowBright="\033[93m"

cBlueBold="\033[1;34m"
cBlue="\033[34m"
cBlueBrightBold="\033[1;94m"
cBlueBright="\033[94m"

cRedBold="\033[1;31m"
cRed="\033[31m"
cRedBrightBold="\033[1;91m"
cRedBright="\033[91m"

# -----------------------------------------------------------------------------
# enable DOCK auto-hide, and set the animations to minimal values
# -----------------------------------------------------------------------------

echo -e "[ ${cGreenBright}DOCK${cClear} ] auto-hide, short delay";

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0.01
defaults write com.apple.dock autohide-time-modifier -float 0.12

# window hide effect - "scale"
defaults write com.apple.dock mineffect -string scale

# duration of desktop switching animation reduction
# defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock expose-animation-duration -float 0.12

killall Dock 2>/dev/null || true

# -----------------------------------------------------------------------------
