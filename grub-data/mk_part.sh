# Three partitions ... MSDOS 512M EFI and LINUX EXT[234]
# Format start size type bootable

. grub_conf justvars

ALREADY=$(mount | grep $INSTROOT)
if [ "$ALREADY" !=  "" ] ; then
    echo "Please unmount USB first (./umount_grub.sh)"
    exit 1
fi

echo 'label:mbr' | sudo sfdisk --wipe always $GRUBROOT <<SEOF
,100M,c,*
,256M,U,*
,10G,L,
SEOF

sudo mkfs.vfat  "$GRUBROOT"1
sudo mkfs.vfat  "$GRUBROOT"2
sudo mkfs.ext4 -F "$GRUBROOT"3

# EOF
