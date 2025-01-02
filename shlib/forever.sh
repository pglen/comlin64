#!/bin/bash

echo forever $1 $2

CNT=1
while [ "1" = "1" ] ; do
	#echo $CNT
	#logger "Spawned $1 $CNT"
	$1 #>/dev/null 2>&1

    sleep .2
	CNT=$(($CNT+1))
done
