#!/bin/bash
#SC2004

# Loop forever (50 msec sleep (good if boo boo))
# Repeats too fast if more than 10 / per sec
#   sleep 2 sec if too fast

SLEEPOVER=2; SLEEPWAIT=0.05; MAXREP=10

#echo called forever $@

while getopts 'vw:n:m:h' opt; do
  case "$opt" in
    w)
      SLEEPWAIT=$OPTARG
      #echo "Processing option 'w' $SLEEPSEC"
      ;;
    v)
      VERBOSE=1
      #echo "Processing option 'v' $SLEEPSEC"
      ;;
    n)
      MAXREP=$OPTARG
      #echo "Processing option 'n' $MAXREP"
      ;;
    h)
        echo -e "Usage: $(basename $0) [ -w wait ] [ -n max_persec ] command(s)"
        exit 1
      ;;
    ?)
      exit 1
      ;;
   esac
done

shift $(( OPTIND - 1 ));

CNT=0; FREQ2=$(date +%s) ; FREQ=$FREQ2

while : ; do
	#echo $CNT
	if [ $((VERBOSE)) -gt $((0)) ] ; then
        echo "Executing: $@"
    fi
    "$@"         # EXEC is here
    FREQ2=$(date +%s)
    if [ $((FREQ2)) -ne $((FREQ)) ]; then
        #echo; echo tick $CNT
        CNT=0
        FREQ=$FREQ2
    fi
    if [ $((CNT)) -gt $((MAXREP)) ] ; then
        if [ $(($VERBOSE)) -gt 0 ]; then
            echo ; echo "Sleeping on: $1 -- $CNT"
        fi
        sleep "$SLEEPOVER"
        CNT=0
    fi
    sleep "$SLEEPWAIT"
	CNT=$((CNT+1))
done

# EOF
