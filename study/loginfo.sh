#!/bin/bash
#
# Get milli seconds from epoch
getmilli()
{
    echo $(($(date +%s%N)/1000000))
}

SFILE=starttime

tanchor()
{
    #export TTT0
    TTT0=$(getmilli)
    echo "$TTT0" > $SFILE
}

readanchor() {
    read -r TTT0 < $SFILE
}

ptime() {

    local TTT2 TTT3 SECS MSECS
    TTT2=$(getmilli)
    TTT3=$((TTT2-TTT0))
    SECS=$((TTT3 / 1000))
    MSECS=$((TTT3 % 1000))
    printf "%d.%-3d " $SECS $MSECS
    }

loginfo2() {

    # Show info. use: loginfo Level [opts] [strs]
    # Option -t must be the first

    #echo args1: "$@"
    local ARG TT
    ARG=$1; TT=0
    if [ $((VERBOSE)) -lt $((ARG)) ] ; then
        return
    fi
    shift
    while : ; do
        was=0
        case $1 in
            "-t")
            shift; was=1; TT=1
            ;;
            "")
        esac
        if [ $was -eq 0 ] ;then
            break
        fi
    done

    if [ $TT -eq 0 ] ; then
        echo -n "$(ptime) "
    fi

    echo "$@"
}

tanchor
loginfo2 0   "Hello  World unescaped "  "\033[32;1mOK\033[0m"
loginfo2 0 -t -e  "Hello  World no time disp"  "\033[32;1mOK\033[0m"
loginfo2 0 -e  "Hello  World one line "  "\033[32;1mOK\033[0m"
loginfo2 0 -n "Hello World  two lines "
loginfo2 0 -t -e "\033[32;1mOK\033[0m"

