#!/bin/bash


uptime() {

    local TTT SSS
    SSS=$1
    TTT=$(cat /proc/uptime | awk '{print $1}')

    #echo $TTT
    HH=$(echo "$TTT  / 3600 " | bc)
    MM=$(echo "($TTT / 60) % 60" | bc)
    SS=$(echo " ($TTT  % 60) " | bc)
    NN=$(echo "($TTT % 1) * 100" | bc)

    if [ "1" == "$1" ] ; then
        #echo $HH:$MM:$SS $NN
        printf "%02.0f.%02.0f \n" $SS $NN
    elif [ "2" == "$1" ] ; then
        printf "%02.0f:%02.0f.%02.0f\n" $MM $SS $NN
    else
        printf "%02.0f:%02.0f:%02.0f.%02.0f\n" $HH $MM $SS $NN
        #echo $MM:$SS $NN
    fi
}

#HHH=$((60*60))
#echo $HHH
#echo $((TTT/HHH))
#echo $(((TTT%HHH)/60))
#echo $((TTT%60))

uptime 1
uptime 2
uptime

