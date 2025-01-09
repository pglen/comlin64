#!/bin/bash

#echo forever $@

CNT=1
while [ "1" = "1" ] ; do
	#echo $CNT
	#echo "Spawning: $@"
	$1 $2 $3 $4 $5 $6 $7 $8 #>/dev/null 2>&1
    sleep .2
	CNT=$(($CNT+1))
done
