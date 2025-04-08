
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

    #echo args1: "$@"
    local ARG NN TT
    ARG=$1; NN="" ; TT=""
    if [ $((VERBOSE)) -ge $((ARG)) ] ; then
        shift
        #echo args2: "$@"

        while getopts 'net' opt; do

            case $opt in
                n)
                    NN="$NN-n "
                    ;;
                e)
                    NN="$NN-e "
                    ;;
                t)
                    TT="1"
                    ;;

                ?)
                    #echo no arg: $opt
                    break
                    ;;
            esac
        done

        shift "$(($OPTIND -1))"
        if [ "$TT" == "" ] ; then
            echo -n "$(ptime) "
        fi
        echo $NN "$*"
    fi
}

tanchor
loginfo2 0 -e  "Hello  World "  "\033[32;1mOK\033[0m"
loginfo2 0 "$*"
#echo -e " \033[32;1mOK\033[0m"
