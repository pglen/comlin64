                      BOOT Troubleshooting

 ComLin will boot from most any machine. The boot scripts can be found in
./initramfs/*

 The boot scripts are sourced from Comlin's initramfs, and customized.
Most of the features of Comlin's system are preserved.

 Added features:

    root=(/dev/xxx) is now optional. Not specifying root will permit Comlin
    to seach for a root drive. Root drive is found as an ext4 drive with
    the file 'comboot' at the root.

    The  script drops to a shell on error before it returns to the kernel.
    this way the Comlin messages can be read before the kernel polluted the
    screen with it's fault dump. On fault, the kernel will reboot in ten
    seconds. This way unattended systems may recover by themselves.

 Debug options:

    Comlin's prompts are intact. Here is a short list:

         rdbreak=cmdline
         rdbreak=pre-udev
         rdbreak=pre-trigger
         rdbreak=initqueue
         rdbreak=pre-mount
         rdbreak=mount
         rdbreak=pre-pivot
         rdbreak

    See man Comlin for more info.

    Syslinux's options / keystrokes are intact. Here is a short list:

        TAB on syslinux start will allow you to edit the command line.
        ENTER in syslinux will start the currently selected item
        Up / Down arrow will navigate between menu items


    Just add yours.


