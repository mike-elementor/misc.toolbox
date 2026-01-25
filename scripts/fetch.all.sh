#!/usr/bin/env bash

# -----------------------------------------------------------------------------

cClear="\e[0m"

cGreenBold="\e[1;32m"
cGreen="\e[32m"
cGreenBrightBold="\e[1;92m"
cGreenBright="\e[92m"

cYellowBold="\e[1;33m"
cYellow="\e[33m"
cYellowBrightBold="\e[1;93m"
cYellowBright="\e[93m"

cBlueBold="\e[1;34m"
cBlue="\e[34m"
cBlueBrightBold="\e[1;94m"
cBlueBright="\e[94m"

cRedBold="\e[1;31m"
cRed="\e[31m"
cRedBrightBold="\e[1;91m"
cRedBright="\e[91m"

# -----------------------------------------------------------------------------

__DIR="$(dirname "$(realpath "$0")")"
__FILTER="$1"

# -----------------------------------------------------------------------------

fetch_in() {
    ( cd "$1" && git fetch; );
}

filter_by() {
    local needle="$1"
    local haystack="$(basename "$2" )"

    [[ -z "$needle" ]] && return 0

    # return the result of the last command
    [[ "${haystack}" == *"${needle}"* ]]
}

# -----------------------------------------------------------------------------

echo ""
echo -e "[ ${cGreenBrightBold}PROCESSING${cClear} ]:"
echo ""

for f in "$__DIR"/*/;
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

# -----------------------------------------------------------------------------

echo -e "[ ${cGreenBrightBold}DONE${cClear} ]"
echo ""
