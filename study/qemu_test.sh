#!/bin/bash

sudo qemu-system-x86_64 -m 4G  \
        -cpu host \
        -display gtk -vga virtio -device virtio-vga,xres=800,yres=600 \
        -smp sockets=1,cores=2,threads=2 \
        -enable-kvm -hdb /dev/sdb \
	-bios /usr/share/ovmf/OVMF.fd -boot d \


#    -audiodev alsa,id=sample \
#	-usb \
#	-device usb-mouse \
#,format=raw \
#-display sdl -vga none -device virtio-vga,xres=800,yres=600 \
# accel=kvm

# EOF
