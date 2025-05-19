#!/bin/bash

# Create a new sum for the project

SUMFILE=$(pwd)/sys-SUMFILE
TMPFILE=$(pwd)/sys-sha1.tmp
HFILE=$(pwd)/sys-sha1.sum

#echo $SUMFILE $TMPFILE $HFILE

START=../comlin64-lite-000

pushd `pwd` >/dev/null

cd $START
if [ $? -ne 0 ] ; then
    echo "Cannot CD to target: $START"
    exit 1
fi

echo -n "Checksuming system... "
#cp sha1.sum sha1.sum.old >/dev/null 2>&1
#find . -maxdepth 1 -type f -exec shasum {} >$TMPFILE \;
find .  -type f -exec shasum {} >$TMPFILE \;
echo OK

echo -n "Cleaning tmp files ... "
# Remove SUMFILE and sha* files from the check
cat $TMPFILE | grep -E -v "(sys-SUMFILE)|(sys-sha1.tmp)|(sys-sha1.sum)" > $HFILE
rm $TMPFILE
echo OK

# The sumfile should also be checked against auxiliarry sources
echo -n "Generating SUMFILE ... "
shasum $HFILE > $SUMFILE
echo OK

popd

# EOF
