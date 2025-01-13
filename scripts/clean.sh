#!/bin/bash

# This script is used to clean generated files

. ./config_build nocheck
. "$SCRIPTS"/misc/lib/lib_fail

HERE=`pwd`
PROJ=`basename $HERE`

#echo "Cleaning .."

rm -rf _work/*
rm -rf _kernel/*
rm -rf _system/*

rm -f $TMPDIR/*  >/dev/null 2>&1
rm -f $BACKUPDIR/*  >/dev/null 2>&1

#sudo umount "$MOUNTPOINT" > /dev/null 2>&1
#echo Done.

# EOF
