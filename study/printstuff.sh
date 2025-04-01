#!/bin/bash

getmilli()
{
    echo $(($(date +%s%N)/1000000))
}

TTT0=$(getmilli)
#echo $TTT0

sleep .1
TTT2=$(getmilli)
printf "time 1: %d ms\n" $((TTT2-TTT0))
sleep .1
TTT3=$(getmilli)
printf "time 2: %d ms\n" $((TTT3-TTT0))

