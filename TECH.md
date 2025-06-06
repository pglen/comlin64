                             TECHNOLOGIES

 Community Linux relies on open source technologies. Naturally, in that
same spirit, we shared our additions to it. Below, is a short description
of the technologies we added, and the reasons for adding it.

 This document was carried over from the 32 bit edition, and edited for
64 bit changes.

1.) Runlevel less operation.

We maintain the OS state in shell scripts. Thanks to the designers
of the kernel, it is stateless, the user space maintains the concept of
run levels, in our case, no run levels. In the current version of ComLin64,
we use the new preinit shell script, and kept the runlevel less operation.

2.) Listeners.

  Because there are no runlevels, we added some listeners to compensate
for the lack of runlevel messages. There are listeners for removable drives,
 media change, the power switch, and some other minor events.

3.) Wireless.

  The wireless utility is updated to use the new 80211 stack, iw and family.
The wireless front end is the standard Gnome front end.

4.) Utilities.

 Utilities that require root access are now pre-pended with a graphical (GUI)
sudo called 'beesu', which is open source.

5.) One user operation.

 Community Linux is deigned to run as a personal class unix, only one user
is created. This in in harmony with typical on-line and embeeded computing.

  Naturally, all the multi user facitilies are avalable for those  who need it.
Multiple users can be created, just like any other Linux. In the major use case,
(embedded) they are not needed.

  User privacy can achieved by encrypted file/dir access. This also reinforces
Community Linux as a personal class operating system. The default user
(named: user) is in the sudoers file, so one can administer the system
with the sudo utility. (or beesu for GUI)

 The initial 'user' pass is 'user' (without the quotes) The root user is
enabled, and the initial pass for 'root' is 'root'. Make sure you change
these passes before real life deployment.

6.) Encrypted directory.

  The directory ~/encrypted/documents is a pre-set encrypted folder. The
initial pass is '1234' (without the quotes) Make sure you change this
pass before using it for real data.

                               Appendix
     _________________________________________________________________


Description of the COMLIN Linux boot procedure

    o The system loads the MBR of the USB drive
    o MBR loads the boot sector of the USB drive, containing syslinux
    o Syslinux loads the kernel and initrd
    o The kernel jumps to initrd, and initrd loads real root from usb
    o The real root walks thru a set of scripts to bring up the system.

The  initrd process:

    1. The /init is executed, and walks though the normal dracut process
    2. It attempts to mount drives, searches for the file '/comboot'
    3. If no comboot file found, prompts the user
    3. If file found, chroots to real root, exec /sbin/init,

The  init process:

    1. /sbin/init is executed, and starts startup.sh
    2. startup.sh spawns a new terminal with startupx.sh
    3. startupx.sh spawns the zombie collector and startup2.sh
    4. In startup2.sh the S-* scripts are executed
    5. The last S-* script starts X, and blocks

    The system is now in operational stage, enjoy.

The shutdown process:

    1. When X is done, control is returned to startup2.sh
    2. The K-* scripts are executed
    3. Control is returned to startup.sh (symmetry)
    4. Remaining processes are killed, file-systems unmounted
    5. Control is transferred to linuxdown.sh

    As the system starts and ends with 'startup'.sh, it has a certain
    beauty in its symmentry.
     _________________________________________________________________

# EOF
