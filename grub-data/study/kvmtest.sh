sudo qemu-system-x86_64 -device piix3-usb-uhci \
    -drive id=pendrive,file=/dev/sdb,format=raw,if=none   \
    -device usb-storage,drive=pendrive  \
    -boot menu=on
