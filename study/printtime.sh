#!/bin/bash

# Get milli seconds from epoch
getmilli()
{
    echo $(($(date +%s%N)/1000000))
}

tanchor()
{
    export TTT0
    TTT0=$(getmilli)
    echo "$TTT0" > starttime
}

readanchor() {
    read -r TTT0 < starttime
}

ptime() {
    TTT2=$(getmilli)
    TTT3=$((TTT2-TTT0))
    SECS=$((TTT3 / 1000))
    MECS=$((TTT3 % 1000))
    printf "%3d.%-3d " $SECS $MECS
    }

#echo "epoch" $TTT0

tanchor
#TTT0=$((TTT0-$((1235*1000+333))))

# Calc avg delay:
#avg=0
#for aa in {1..10} ; do
#    TTT2=$(getmilli)
#    sleep 0
#    diffx=$(($TTT2 - $TTT0))
#    #echo -n "diff:$diffx "
#    avg=$((avg+diffx))
#    TTT0=$TTT2
#done
#echo AVG DELAY = $((avg/10))

#printf "time 1: %d ms\n" $((TTT2-TTT0))
#TTT2=$(getmilli)
#printf "time 1x: %d ms\n" $((TTT2-TTT0))

#sleep .01
#TTT3=$(getmilli)
#printf "time 2: %d ms\n" $((TTT3-TTT0))

#TTT0=$(getmilli)
#echo Wait 1 Sec ..
#sleep 1

#echo 12345678901234567890
ptime; echo -n "Start something "
sleep 0.2
echo OK
ptime; echo -n "Start another thing "
sleep 0.2
echo OK

readanchor
ptime; echo -n "Start another thing "
sleep 0.2
echo OK

# EOF
