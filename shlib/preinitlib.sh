#!/bin/bash

examine() {
    #echo "examine:" path: $1 file: $2 event: $3
    echo Changed: $1$2
    cat $1$2
}

# Temporary SHELL
tmpshell() {
    #echo called tmpshell  with \'$1\'
    _PROMPT="tmp shell $ "
    if [ "$1" != "" ] ; then
        _PROMPT=\"$1\"
    fi
    #echo "exec tmpshell with $_PROMPT"
    setsid -c -w /bin/bash --rcfile <(echo PS1=$_PROMPT) -i
}

# ------------------------------------------------------------------------
# Get arg from command line. Return 1 for arg.

getargx() {
    local oo
    if [ "$CMDLINE" = "" ]; then
        if [ -f /var/cmdline ] ; then
            read CMDLINE </var/cmdline
        fi
    fi
    for oo in $CMDLINE; do
	   [ "$oo" = "$1" ] && return 0;
    done
    return 1
}

# EOF