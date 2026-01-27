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

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo -e "[ ${cRedBrightBold}FAIL${cClear} ] ${cRed}Not inside a git repository${cClear}"
    echo ""
    exit 1
fi

# -----------------------------------------------------------------------------

AUTO_YES=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -y|--yes)
            AUTO_YES=true
            shift
            ;;
        *)
            echo -e "[ ${cRedBrightBold}FAIL${cClear} ] ${cRed}Unknown option: $1${cClear}"
            exit 1
            ;;
    esac
done


# -----------------------------------------------------------------------------

UNAME=""
EMAIL=""

# -----------------------------------------------------------------------------

confirm() {
    local message="$1"

    if $AUTO_YES; then
        echo -e "$message ${cBlueBright}(auto-yes)${cClear}"
        return 0
    fi

    read -r -p "$message [y/N]: " reply

    [[ "$reply" =~ ^([yY]|yes|Yes|YES)$ ]]
}

# -----------------------------------------------------------------------------

# Detect if stdin has data
if [ -t 0 ]; then
    # Interactive mode
    read -r -p "Git user name: " UNAME
    read -r -p "Git user email: " EMAIL
else
    exec 3<&0
    exec </dev/tty

    # Read from stdin
    IFS= read -r UNAME <&3 || true
    IFS= read -r EMAIL <&3 || true
fi

# -----------------------------------------------------------------------------

# Validate input
if [[ -z "${UNAME}" || -z "${EMAIL}" ]]; then
    echo -e "[ ${cRedBrightBold}FAIL${cClear}] Name or email is empty"
    echo ""
    exit 1
fi

# -----------------------------------------------------------------------------

echo -e "[ ${cGreenBrightBold}SETUP${cClear} ]: ${cGreenBright}Git repository configuration${cClear}"
echo "You're about to set local git configuration using:"
echo ""
echo -e "   user.name  = ${cYellowBrightBold}$UNAME${cClear}"
echo -e "   user.email = ${cYellowBrightBold}$EMAIL${cClear}"
echo ""

if ! confirm "Do you want to continue?"; then
    echo ""
    echo -e "[ ${cRedBrightBold}ABORTED${cClear} ] Cancelled by the user"
    echo ""
    exit 1
fi


# -----------------------------------------------------------------------------

# Apply git config (local only)
git config --local user.name "${UNAME}"
git config --local user.email "${EMAIL}"

# -----------------------------------------------------------------------------

echo ""
echo -e "[ ${cGreenBrightBold}DONE${cClear} ] ${cGreen}Local git config was updated successfully${cClear}"
echo ""

# -----------------------------------------------------------------------------
