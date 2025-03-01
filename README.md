#   ComLin64 Community Linux Boot-able USB

## This is the successor of the ComLin32 project for 64 bit PCs.

### Code in motion, nothing much usable.

!! UNTESTED -- USE IT WITH CARE!!

Preface

    *   The Community Linux project aims to provide a simple Linux distribution
        for the masses.
    *   It is a fully functional GUI right from the CD/Thumb drive within the first
        30 seconds of power up. (21 seconds measured 0n dell laptop)
    *   It is installation-less, and it looks and feels like a real hard drive
        installation.
     _________________________________________________________________

Goals

    *   A simple (graphical) UI to interact with the system. Community Linux
        GUI is targeted to that audience.
    *   A reliable, fast system with few options.
    *   Fast recovery by replicating the original jump drive.
    *   To allow low cost PC deployment without moving parts like hard drive
        and / or CD rom. Examples include low cost (student) laptop, home
        automation, video security, industrial controls, cash registers,
        rugged system(s) suitable for law enforcement / military.
    *   Built in, easy to use optional security by encryption.
     ________________________________________________________________

System requirements:

    ComLin64 Linux will work on most 64 bit PC platforms. With more than
    5000 drivers available, ComLin64  covers almost all possible  platform
    combinations.

Recommended (minimum) system requirements:

    While ComLin64 Linux will work on the most basic hardware. For responsive
    operation we recommend at least 2 Gig of RAM (or more),
    1.6 GHz processor (or faster) and a 16/32 Gig (or larger) USB drive.
        (also called Jump Drive, a Thumb Drive or a Flash Drive).
    Tested: 1 Gig of Ram, 1.2 GHz CPU, 16 Gig Jump drive -- works OK

The ComLin64 .ISO should boot and be usable immidiately.

ComLin64 System Creation requirements:

    This is of course if you opted for the source creation.

    1.) A host Linux system to create the jump drive with. (we used Ubuntu 22.x)
        Alternatively, one can create a new ComLin64 system from a ComLin64
        boot drive.
    2.) Jump drive with at least 16 GB capacity. (we used a Verbatim 16GB)
       Smaller jump drive can be used by reducing the freature list, however,
       the 16GB option will have ALL the features of a real hard drive
       installation.
    3.) The creation scripts and ComLin64 system image.
        (downloadable from Github)

     Alternatively, you can order a ready made jump drive from the author.
    (Email address can be found on the GitHub Project page)

Quick Start:

    NOTE: Some of the 32 bit creation utilities are left over from the
    previous version, ignore them.

    Type  'make help' for quick system creation options.
    The Makefile contains brief instructions on different
    stages of the process.
    A stock kernel and system is provided for easy system creation.
    ComLin64ux can also be created from most any running system, but that is
    task reserved for expert sysadmins. (too many things to configure)

Detecting the Jump Drive:

    Execute 'make detect' and follow the prompts to auto detect your drive.
    Make sure you configure the jump drive correctly, as this set of scripts
    partitions and formats drives. To verify the configuration look at
    the file config_drive and compare it against the output of
    'mount' and 'df'.

Care and feeding:

    The initial setup contains two user accounts: 'root' and 'user'
    root pass is 'root' (without the quotes)
    user pass is 'user' (without the quotes)
    encryption pass is '12345678' (without the quotes)
    key chain pass is '12345678' (without the quotes)

    Make sure you change these passwords on first successful boot.
    If you can, boot without a network cable attached, and change the
    passes before connecting to a network.

    Initially, network is firewalled, with only some standard ports open.
	(HTTP, SSH ...) You may enable more firewall ports by editing the
	firewall configuration.

Runlevel-Less operation

    To boot faster, and exclude unneeded baggage present on a full system,
    ComLin64 Linux operates without the distinction of runlevels. The system
    instead, cycles through a set of shell scripts.
    To aid troubleshooting, checkpoints are introduced, and one can press
    the ENTER key to temporarily drop to a shell prompt. Exiting the temporary
    shell will continue the boot process from the point of interruption.

Installation-Less operation

    ComLin64 Linux should operate on most every hardware combination supported
    by Linux. As of this writing, there are more then 3000+ different hardware
    drivers / items supported. ComLin64 Linux detects hardware by reading the
    system buses, and loading the drivers on the fly. Thanks to modern
    hardware, the identification / driver loading is fast. The system boots
    about the same speed as a regular hard drive boot. ComLin64 works right
    out of the box without installation.

Special added Utilities

    Some additional utils where necessary, and some existing utilities had
    insufficient functionality. For example the 'getkey' utility did not work
    correctly on the boot terminal. Hence, new utility was called upon, and
    written that is simpler, and works on broken terminals. (Like the
    initial boot terminal) We aptly named the utility 'keyget'. For a full
    list of added utils see the source in ./apps directory.
    (Luke; Use the source)

Security Measures:

    The files in the project are protected by an sha1 sum. The sums are stored
    in the file "sha1.sum". The sum file is protected by the file SUMFILE.
    Make sure the SUMFILE signature checks out as well. If you want to,
    obtain a sum file from a  different source to make sure it is not
    tempered with. (for example: the project page).
    Executing ./checksum.sh should verify the project's integrity. Note that
    the sum files themselves are not verifiable without the external
    second verifyer. (chicken and egg conundrum) Hence the redirection to
    get a sum file (or sum file sum) from different (not tempered) source.

Data Security and Privacy Measures:

    ComLin64 has an encrypted subsystem, that is controllable from the padlock
    icon on the top panel. Click on the padlock icon, and select the
    encrypted folder you wish to activate. You will be prompted for a
    password, and the folder will become accessible. You may copy/save
    any file in the encrypted folder,  it will be automatically encrypted.
    The initial password is '1234' for the stock encrypted folder,
    make sure you change it before deployment.

                                Appendix
     _________________________________________________________________


Description of the ComLin64 Linux boot procedure

    o The system loads the MBR of the USB drive
    o MBR loads the boot sector of the USB drive, containing GRUB
    o GRUB loads the kernel and initramfs
    o The kernel jumps to initramfs, and that loads real root from usb
    o The real root walks thru a set of scripts to bring up the system.

    1. preinit is executed, and starts many services
    2. Spawn virtual terminal like most linux installation
    3. spawns the zombie collector
    4. In startup2.sh the S-* scripts are executed
    5. The last S-* script starts X, and blocks

The shutdown process:

    1. When X is done, control is returned to the preinit sript
    2. The K-* scripts are executed
    3. Control is returned to startup.sh (symmetry)
    4. Remaining processes are killed, file-systems unmounted
    5. Control is transferred to linuxdown.sh
     _________________________________________________________________

Current Progress:

    Mon 13.Jan.2025  Sound drivers
    Tue 07.Jan.2025  Some correction, pango font display
    Thu 02.Jan.2025  Boots under VBOX into XFCE in under 15 seconds

Credits

    Credits go to all of you who contributed to dependent and / or similar
    projects. To all who tested it, encouraged it, and gave feedback.
    The Community Linux project merits from sum of knowledge of all
    the developers out there.

    Thank You!

    Peter Glen, author  <peterglen99@gmail.com>

    This project is funded by donations. Please consider donating
    on PayPal to the account of peterglen99@gmail.com.

// EOF
