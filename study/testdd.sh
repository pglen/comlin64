

DDEV=/dev/sdb4

if [ $1 != "" ] ; then
    DDEV=$1
fi

BS=$((1024*1024))
SSS=$(lsblk -o size -n -b -D $DDEV)
BBB=$((SSS / BS))
RRR=$((SSS % BS))

echo $DDEV -  $(($SSS/1000000000))GB   bs:$BS
echo blocks:$BBB  total:$SSS   remnant:$RRR

# EOF
