#!/bin/bash
# shellcheck disable=SC1091

. ./config_build

# Pre ask for sudo pass
echo  Testing prompt

if [ "$2" == "" ] ; then
 $KEYGET -t 0  -m "Are you sure you want to $1 $DDEV ? Ctrl-c to abort "
 ERRX=$?
 if [ "$ERRX" != 0 ] ; then
	echo Aborting ...
	exit 1;
 fi
 echo Proceeding ...
 exit 0

fi

