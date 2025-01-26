#
# We created two excutables, following Linux tradition. In the origianl
# implementation, these are symlinks to one excutable, but we are keeping it simple.
#

all: linux_reboot linux_poweroff

clean:
	@rm -f *.o
	@rm -f linux_reboot linux_poweroff

linux_reboot: linux_reboot.c linux_reboot.h
	gcc  linux_reboot.c -o linux_reboot

linux_poweroff: linux_reboot.c linux_reboot.h
	gcc -DCOMPILE_POWEROFF linux_reboot.c -o linux_poweroff

