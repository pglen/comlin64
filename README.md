#   ComLin64 Community Linux Boot-able USB

## This is the successor of the ComLin64 project for 64 bit computers.

### Code in motion, nothing usable.

!! UNTESTED -- USE IT WITH CARE!!

Preface

    *   The Community Linux project aims to provide a simple Linux distribution
        for the masses.
    *   It is a fully functional GUI right from a jump drive within the first
        minute of power up.
    *   It is installation-less, and it looks and feels like a real hard drive
        installation.  (See video - keyword 'ComLin6464')
     _________________________________________________________________

Goals

    *   A simple (graphical) UI to interact with the system. Community Linux
        GUI is targeted to that audience.
    *   A reliable, fast system with few options.
    *   Fast recovery by replicating the original jump drive.
    *   To allow low cost PC deployment without moving parts like hard drive
        and / or CD rom. Examples include low cost (student) laptop, home
        automation, video security, industrial controls, rugged system(s)
        for law enforcement / military.
    *   Built in, eazy to use optional security by encryption.
     ________________________________________________________________


System requirements:

    ComLin64 Linux will work on most 64 bit PC platforms. With more than
    3000 drivers   available, ComLin64  covers almost all possible  platform
    combination(s).

Recommended Minimum System requirements:

    While ComLin64 Linux will work on the most basic hardware. For responsive
    operation we recommend at least 2Gig MB of RAM, 1.6 GHz
    processor (or faster) and a 32 Gig USB drive
    (also called Jump Drive, a Thumb Drive or a Flash Drive).

ComLin64 System Creation requirements:

    1.) A host Linux system to create the jump drive with. (we used Ubuntu 22.x)
        Alternatively, one can create a new ComLin64 system from a ComLin64
        boot drive.
    2.) Jump drive with at least 16 GB capacity. (we used a Verbatim 16GB)
       Smaller jump drive can be used by reducing the freature list, however,
       the 16GB option will have ALL the features of a real hard drive
       installation.
    3.) The creation scripts and ComLin64 system image.
        (downloaded from Sourceforge)
    4.) The syslinux utility / package
        (usually in distros)
    5.) user with sudo  capability
        (usually in distros)

     Alternatively, you can order a ready made jump drive from the author.
    (Email address can be found on the Sourceforge Project page)

Quick Start:

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
    root pass is 'admin1234' (without the quotes)
    user pass is 'user1234' (without the quotes)
    encryption pass is '1234' (without the quotes)
    key chain pass is '1234' (without the quotes)

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
    o MBR loads the boot sector of the USB drive, containing syslinux
    o Syslinux loads the kernel and initrd
    o The kernel jumps to initrd, and initrd loads real root from usb
    o The real root walks thru a set of scripts to bring up the system.

The OLD initrd process (pre V.1, obsolete):

    1. first the script /linuxrc is executed
    2. linuxrc searches for a drive with the file /ComLin64
    3. linuxrc mounts the  drive under /mnt/system
    4. linuxrc changes the root device with pivot_root to /mnt/system
    5. linuxrc starts the normal boot process by invoking /sh/startup.sh
    6. startup.sh spawns a new terminal with startup2.sh
    7. The S-* scripts are executed
    8. The last S-* script starts X, and blocks

The NEW initrd process:

    1. init is executed, and starts startup.sh
    2. startup.sh spawns a new terminal with startupx.sh
    3. startupx.sh spawns the zombie collector and startup2.sh
    4. In startup2.sh the S-* scripts are executed
    5. The last S-* script starts X, and blocks

The shutdown process:

    1. When X is done, control is returned to startup2.sh
    2. The K-* scripts are executed
    3. Control is returned to startup.sh (symmetry)
    4. Remaining processes are killed, file-systems unmounted
    5. Control is transferred to linuxdown.sh
     _________________________________________________________________

Credits

    Credits go to all of you who contributed to dependent and / or similar
    projects. To all who tested it, encouraged it, and gave feedback.
    The Community Linux project merits from sum of knowledge of all
    the developers out there.

    Thank You!

    Peter Glen, author  <peterglen99@gmail.com>

    This project is funded by donations. Please consider donating
    on PayPal to the account of peterglen99@gmail.com.

