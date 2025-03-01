#! /bin/bash

# some defaults
user="root"
suargs="-p"
force="no"

# parse commandline
if [[ $# -eq 0 ]]; then
    echo "Usage: ${0##*/} [-f] [-u user] [--] "
    exit 1
fi

OPTIND=1
while getopts "u:f" opt; do
    case "$opt" in
        f) force="yes" ;;
        u) user="$OPTARG" ;;
        *) echo
    esac
done
shift $((OPTIND - 1))

cmd="$*"

if [[ $force != "no" ]]; then
    # check for sudo
    sudo_check=$(sudo -H -S -- echo SUDO_OK 2>&1 &)
    if [[ $sudo_check == "SUDO_OK" ]]; then
        eval sudo "$cmd"
        exit $?
    fi
fi

# get password
#--class="GSu" \
pass=$(yad \
    --class="GSu" \
    --title="Password" \
    --text="Enter password for user <b>$user</b>:" \
    --image="dialog-password" \
    --entry --hide-text)
[[ -z "$pass" ]] && exit 1

# grant access to xserver for specified user
#xhost +${user}@ &> /dev/null

# run command
fifo_in="$(mktemp -u --tmpdir gsu.empty.in.XXXXXXXXX)"
fifo_out="$(mktemp -u --tmpdir gsu.empty.out.XXXXXXXXX)"
#echo "executing" 'pass='$pass "args="$suargs "user="$user cmd="$cmd"
LC_MESSAGES=C
./empty  -f -i "$fifo_in" -o "$fifo_out"  -L sess su "$suargs" "$user" -c "$cmd"
#echo ret=$ret fifo=$fifo_in fifo=$fifo_out
ret=$?
[[ $ret -eq 0 ]] && ./empty -w -i "$fifo_out" -o "$fifo_in" -L sess "word:" "$pass\n"

exit $?

# EOF