SIZE=$(lsblk -d -b -o SIZE -n /dev/sdb)
MBS=$((SIZE / (1000*1000) ))
echo Getting $MBS 
dd status=progress if=/dev/sdb of=32USB.img bs=1M count=$MBS
echo OK
