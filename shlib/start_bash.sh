#!/bin/bash

export USER=root
export HOME=/root

#echo "Starting BASH Session"
TTY=$(tty)
PS1="$TTY \w # "
setsid -c -w /bin/bash

# EOF
