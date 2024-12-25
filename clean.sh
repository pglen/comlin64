#!/bin/sh

# This script is used to clean generated files
# Portions Copyright (C) by Peter Glen. See open source license for details.

HERE=`pwd`
PROJ=`basename $HERE`

# Do some cleaning
echo "Cleaning .."

rm -rf _work/*
rm -rf _kernel/*
rm -rf _system/*
rm -rf _boot/*

make -C apps clean

echo Done.


