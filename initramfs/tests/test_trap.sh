#!/bin/bash

#. ../lib/shlib/comlin.sh

wd=$(pwd)
#trap "echo Signal caught SIGINT; /bin/bash" SIG SIGINT; /bin/bash" SIGINT
#trap "exec chroot $wd ./test_trap_exec.sh" SIGINT
trap "su -c exec chroot $wd " SIGINT

echo before $$
kill -SIGINT $$
echo after $$


# EOF