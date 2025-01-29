#! /bin/bash

# some defaults
user="root" ; suargs="-p"

if [ "$1" == "reboot" ] ; then
    cmd="linux_reboot -f"
    msg="reboot"
else
    cmd="linux_poweroff -f"
    msg="shutdown"
fi

pass=$(yad \
    --class="GSu" \
    --text="Enter $msg password for '$user'" \
    --image="dialog-password" \
    --title="" \
    --width=400 \
    --entry --hide-text)

# Empty pass
[[ -z "$pass" ]] && exit 1

fifo_in="$(mktemp -u --tmpdir gsu.empty.in.XXXXXXXXX)"
fifo_out="$(mktemp -u --tmpdir gsu.empty.out.XXXXXXXXX)"

#echo "executing" 'pass='$pass "args="$suargs "user="$user cmd="$cmd"

# Run command
LC_MESSAGES=C
/sbin/empty  -f -i "$fifo_in" -o "$fifo_out"  -L sess su "$suargs" "$user" -c "$cmd"
ret=$?
#echo ret=$ret fifo=$fifo_in fifo=$fifo_out
[[ $ret -eq 0 ]] && /sbin/empty -w -i "$fifo_out" -o "$fifo_in" "word:" "$pass\n"
ret=$?

if [ $((ret)) -ne 0 ] ; then
    #echo $ret
    $(yad \
    --text-align="center"\
    --width=300 \
    --button=OK:0 \
    --text="Invalid Pass" \
    --title="Invalid Pass" \
    )
fi

exit $ret

# EOF