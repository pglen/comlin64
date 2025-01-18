#!/bin/bash

# Loop forever (50 msec sleep (good if boo boo))
# Repeats too fast if more than 10 / per sec
#   sleep 2 sec if too fast

SLEEPSEC=2; MAXREP=10

#echo called forever $@

while getopts 'w:n:' opt; do
  case "$opt" in
    w)
      SLEEPSEC=$OPTARG
      echo "Processing option 'w'" $SLEEPSEC
      ;;
    n)
      MAXREP=$OPTARG
      echo "Processing option 'n'" $MAXREP
      ;;
    ?)
      echo -e "Usage: $(basename $0) [ -w waitlen ] [ -n max_num_persec ] subcommands"
      exit 1
      ;;
   esac
done

shift $(( OPTIND - 1 ));

CNT=0; FREQ2=$(date +%s) ; FREQ=$FREQ2

while : ; do
	#echo $CNT
	if [ $(($VERBOSE)) -gt 1 ]; then
        echo "Spawning: $@"
    fi
	$@         # EXEC is here
    sleep .05
    FREQ2=$(date +%s)
    if [ $FREQ2 -ne $FREQ ]; then
        #echo; echo tick $CNT
        CNT=0
        FREQ=$FREQ2
    fi
    if [ $CNT -gt $MAXREP ] ; then
        if [ $(($VERBOSE)) -gt 0 ]; then
            echo ; echo "Sleeping on:" $1 "--" $CNT
        fi
        sleep $SLEEPSEC
        CNT=0
    fi
	CNT=$(($CNT+1))
done

# EOF
