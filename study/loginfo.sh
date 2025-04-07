
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

    #echo args1: "$@"
    local ARG
    ARG=$1
    if [ $((VERBOSE)) -ge $((ARG)) ] ; then
        shift
        #echo args2: "$@"
        echo -n "$(ptime) "
        if [ "$1" == "-n" ] ; then
            shift
            #echo args3: "$@"
            NN="-n"
        else
            NN=""
        fi
        echo $NN "$*"
    fi
}

tanchor
loginfo2 0 -n "Hello  World "
echo " OK"
