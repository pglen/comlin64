#/!/bin/bash

# Script to create file devices from loaded device

FILES=$(find /sys/class/sound -follow -type f -maxdepth 2 -name dev)

for FFF in $FILES ; do
    [ -f "$FFF" ] && MAJOR="`cat "$FFF" | awk -F ":" '{print $1}'`"
    [ -f "$FFF" ] && MINOR="`cat "$FFF" | awk -F ":" '{print $2}'`"
    DEVX="/dev/snd/"$(basename ${FFF%/dev})
    echo -e "File:" $DEVX"      \tMajor/Minor: \t" $MAJOR : $MINOR
    #mknod -m 0660 "$dev" c "$maj" "$min"
    #chown root:audio "$dev"
done