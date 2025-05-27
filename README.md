#  ComLin64 Community Linux Boot-able USB

## This is the successor of the ComLin32 project for 64 bit PCs.

### In Beta. Fully functional.

  If you are reading this file, you have successfully downloaded and
extracted the comlin archive. Make sure you have extracted as root,
so the file permissions are preserved.

## Preface

    *   The Community Linux project aims to provide a simple Linux distribution
        for the masses.
    *   It is a fully functional GUI right from the Thumb drive within the first
        30 seconds of power up. (21 seconds measured on a Dell I5 laptop)
    *   It is installation-less, and it looks and feels like a real hard drive
        installation.

## Goals

    *   A simple (graphical) UI to interact with the system. Community Linux
        GUI is targeted to that audience.
    *   A reliable, fast system with few options.
    *   Fast recovery by replicating the original jump drive.
    *   To allow low cost PC deployment without moving parts like hard drive
        and / or CD rom. Examples include low cost (student) laptop, home
        automation, video security, industrial controls, cash registers,
        rugged system(s) suitable for law enforcement / military.

## System requirements:

    ComLin64 Linux will work on most 64 bit PC platforms. With more than
    5000 drivers available, ComLin64  covers almost all possible  platform
    combinations.

## Recommended (minimum) system requirements:

    While ComLin64 Linux will work on the most basic hardware. For responsive
    operation we recommend at least 2 Gig of RAM (or more),
    1.6 GHz processor (or faster) and a 32 Gig (or larger) USB drive.
        (also called Jump Drive, a Thumb Drive or a Flash Drive).
    Tested: 2 Gig of Ram, 1.2 GHz CPU, 32 Gig Jump drive -- works OK

## ComLin64 System Creation:

    Download the current .gz image and dd it to a 32 gig jump drive.
    (rufus dd mode if you are on windows) If you want different sizes,
    ComLin is customizable, but needs minimum system admin skills.

## ComLin64 System Creation requirements:

    This is of course if you opted for the source creation. The source
    creation gives you full control over features / sizes / partitions ... etc.

    1.) A host Linux system to create the jump drive with. (we used Ubuntu 22.x)
        Alternatively, one can create a new ComLin64 system from a ComLin64
        boot drive.
    2.) Jump drive with at least 32 GB capacity. (or larger)
       Smaller jump drive can be used by reducing the freature list, however,
       the 32GB option will have ALL the features of a real hard drive
       installation.
    3.) The creation scripts in the and comlin64 subdirectory.
        (downloadable from Github or sourceforge)

     Alternatively, you can order a ready made jump drive from the author.
    (Email address can be found on the GitHub Project page or down below)

## Quick Start:

    NOTE: Some of the 32 bit creation utilities are left over from the
    previous version, ignore them.

    Type  'make help' for quick system creation options.
    The Makefile contains brief instructions on different
    stages of the process.
    A stock kernel and system is provided for easy system creation.
    ComLin64 can also be created from most any running system, but that is
    task reserved for expert sysadmins. (too many things to configure)

## Detecting the Jump Drive:

    Execute 'make detect' and follow the prompts to auto detect your drive.
    Make sure you configure the jump drive correctly, as this set of scripts
    partitions and formats drives. To verify the configuration look at
    the file config_drive and compare it against the output of
    'mount' and 'df'.

## Care and feeding:

    The initial setup contains three accounts:
            'root' and 'user'  and a guest account.
    root  pass: is 'root' (without the quotes)
    user  pass: is 'user' (without the quotes)
    guest pass: is 'guest' (without the quotes)

    The pro version has:
        encryption pass is '12345678' (without the quotes)
        key chain pass is '12345678' (without the quotes)

    Make sure you change these passwords on first successful boot.
    If you can, boot without a network cable attached, and change the
    passes before connecting to a network.

    Initially, network is firewalled, with only some standard ports open.
	(HTTP, SSH ...) You may enable more firewall ports by editing the
	firewall configuration.

## Runlevel-Less operation

    To boot faster, and exclude unneeded baggage present on a full system,
    ComLin64 Linux operates without the distinction of runlevels. The system
    instead, cycles through a set of shell scripts.
    To aid troubleshooting, checkpoints are introduced. One can enter
    into the the grub command line (press 'e' on grub load) and specify
    options to temporarily drop to a shell prompt. Exiting the temporary
    shell will continue the boot process from the point of interruption.

## Installation-Less operation

    ComLin64 Linux should operate on most every hardware combination supported
    by Linux. As of this writing, there are more then 3000+ different hardware
    drivers / items supported. ComLin64 Linux detects hardware by reading the
    system buses, and loading the drivers on the fly. Thanks to modern
    hardware, the identification / driver loading is fast. The system boots
    about faster or the same speed as a regular hard drive boot.
    ComLin64 works right out of the box without installation.

## Special added Utilities

    Some additional utils where necessary, and some existing utilities had
    insufficient functionality. For example the 'getkey' utility did not work
    correctly on the boot terminal. Hence, new utility was called upon, and
    written that is simpler, and works on broken terminals. (Like the
    initial boot terminal) We aptly named the utility 'keyget'. For a full
    list of added utils see the source in ./apps directory.
    (Luke; Use the source)

## Security Measures:

    The files in the project are protected by an sha1 sum. The sums are stored
    in the file "sha1.sum". The sum file is protected by the file SUMFILE.
    Make sure the SUMFILE signature checks out as well. If you want to,
    obtain a sum file from a  different source to make sure it is not
    tempered with. (for example: the project page).
    Executing ./checksum.sh should verify the project's integrity. Note that
    the sum files themselves are not verifiable without the external
    second verifyer. (chicken and egg conundrum) Hence the redirection to
    get a sum file (or sum file sum) from different (not tempered) source.

## Data Security and Privacy Measures:

    (disabled for beta)
    ComLin64 has an encrypted subsystem, that is controllable from the padlock
    icon on the top panel. Click on the padlock icon, and select the
    encrypted folder you wish to activate. You will be prompted for a
    password, and the folder will become accessible. You may copy/save
    any file in the encrypted folder,  it will be automatically encrypted.
    The initial password is '1234' for the stock encrypted folder,
    make sure you change it before deployment.

                                Appendix
     _________________________________________________________________


## Description of the ComLin64 Linux boot procedure

    o The system loads the MBR of the USB drive
    o MBR loads the boot sector of the USB drive, containing GRUB
    o GRUB loads the kernel and initramfs
    o The kernel jumps to initramfs, and that loads real root from usb
    o The real root walks thru a set of scripts to bring up the system.

    1. preinit is executed, and starts many services
    2. Spawn virtual terminal like most linux installations
    3. Jumps to postinit
    4. Startx X, and the login program.

## The shutdown process:

    1. When X is done, control is returned to the postinit script
    3. Control is returned to preinit
    4. Remaining processes are killed, file-systems unmounted
    5. Control is transferred back to init intramfs

## Upstream:

    Community Linux64 is derived from Ubuntu 22.04 Package
    installation is fully operational from said repository.
    The packages are last updated on Sun 11.May.2025

## Bugs:

    In a distro with a million moving parts, there are a lot of
    deviations from expectations. One notable is the use of overlay
    file system, where the kernel cannot load dependent modules from the
    overlay. (kernel bug?)
    The work around is to load the dependent module from the init scripts
    or from /etc/modules.

## Github:

    The comlin64 directory is also published on github at:

      https://github.com/pglen/comlin64

    _________________________________________________________________

## Current Progress:

    Mon 13.Jan.2025 Sound drivers
    Tue 07.Jan.2025 Some correction, pango font display
    Thu 02.Jan.2025 Boots under VBOX into XFCE in under 15 seconds
    Sat 10.May.2025 Beta
    Sun 11.May.2025 Uploded to SF
    Mon 26.May.2025 Updated kernel to 6.14.8 (for real time feature)

## Credits

    Credits go to all of you who contributed to dependent and / or similar
    projects. To all who tested it, encouraged it, and gave feedback.
    The Community Linux project merits from sum of knowledge of all
    the developers out there.

    Thank You!

    Peter Glen, author  <peterglen99@gmail.com>

    This project is funded by donations. Please consider donating
    on PayPal to the account of peterglen99@gmail.com.

// EOF
