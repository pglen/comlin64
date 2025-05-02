#!/bin/bash

sudo qemu-system-x86_64 -m 4G  \
        -cpu host \
        -vga std \
        -smp sockets=1,cores=2,threads=2 \
        -enable-kvm -hdb /dev/sdb \
        -bios /usr/share/ovmf/OVMF.fd -boot d

#-display sdl -vga none -device virtio-vga,xres=800,yres=600 \
#-smp threads=2 \
#-display sdl -vga none -device virtio-vga,xres=800,yres=600 \
#-smp cpus=1,cores=2 \
#-cpu host
# accel=kvm

# EOF
