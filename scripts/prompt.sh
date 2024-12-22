#!/bin/bash

. ./config_build

# Pre ask for sudo pass
echo  Testing prompt

if [ x"$2" == x"" ] ; then
 $KEYGET -t 0  -m "Are you sure you want to $1 $DDEV ? Ctrl-c to abort "

 if [ $? != 0 ] ; then
	echo Aborting ...
	exit 1;
 fi
 echo Proceeding ...
 exit 0

fi

