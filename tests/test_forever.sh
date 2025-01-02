#!/bin/bash

echo test_forever.sh

TERMS="tty3 tty4 tty5 tty6 ttyS0"

for TT in $TERMS ; do
    echo $TT
    ../shlib/forever.sh "exec setsid agetty $TT linux >/dev/null 2>&1" >/dev/null 2>&1 &
done

