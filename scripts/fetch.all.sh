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

__DIR="$( dirname "$0" )"
__FILTER="$1"

# -----------------------------------------------------------------------------

filter_by() {
    local needle="$1"
    local haystack="$(basename "$2" )"

    [[ -z "$needle" ]] && return 0

    # return the result of the last command
    [[ "${haystack}" == *"${needle}"* ]]
}

fetch_in() {
    ( cd "$1" && git fetch; )
}

fetch_in_folder() {
    local workdir="$1"

    echo -e "[ ${cGreenBrightBold}PROCESSING${cClear} ]: ${cGreenBright}${workdir}${cClear}"
    echo ""

    for f in "${workdir}/"*/;
    do
        filter_by "$__FILTER" "$f" || continue

        if [ -d "$f" ];
        then
            echo -e "[ ${cYellowBright}FETCHING${cClear} ]: ${cYellowBright}$f${cClear} ${cBlue}"

            fetch_in "$f"

            echo -e "${cClear}[ ${cGreen}FINISHED${cClear} ]"
            echo ""
        fi
    done
}

# -----------------------------------------------------------------------------

echo ""

fetch_in_folder "${__DIR}"

# -----------------------------------------------------------------------------

echo -e "[ ${cGreenBrightBold}DONE${cClear} ]"
echo ""
