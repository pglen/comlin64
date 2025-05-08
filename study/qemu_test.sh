#!/bin/bash

sudo qemu-system-x86_64 -m 4G  \
        -cpu host \
        -display sdl -vga virtio -device virtio-vga,xres=800,yres=600 \
        -smp sockets=1,cores=2,threads=2 \
        -enable-kvm -hdb /dev/sdb,format=raw \
        -bios /usr/share/ovmf/OVMF.fd -boot d

#-display sdl -vga none -device virtio-vga,xres=800,yres=600 \
# accel=kvm

# EOF
