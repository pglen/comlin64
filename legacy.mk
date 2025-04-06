# Makefile include contains old and obscure init targets
# Instead of deleting it, we moved it out of the way.
# This assures that in the future - one may reuse the script

# Wed 02.Apr.2025  extracted from main make

#SUDO=@echo ${shell ./py/crypter.py -i -d <.crypted} | sudo -n -S
# Else ... allow the sudo prompt as one normally would
#SUDO=sudo

new: prompt
	sudo ./scripts/make_part go
	sudo ./scripts/make_fs go
	@echo "Remove and Reinsert drive for next steps"

new2:
	sudo ./scripts/make_part go
	sudo ./scripts/make_fs go

bootimage:
	@sudo ./scripts/make_toritoimage

cdboot:
	@sudo ./scripts/make_cdboot

copy:
	@sudo scripts/make_usb

syslin:
	@sudo ./scripts/make_syslin go

cleanusb:
	@sudo ./scripts/make_cleanusb

cleanusbsock:
	@sudo ./scripts/make_cleanusbsock

copyusb:
	@sudo ./scripts/make_copyusb

getlite:
	@sudo ./scripts/make_getlite

cycle: putkern syslin cpscripts umount
	@echo "Done Cycle"

bigcycle: copyusb putkern syslin cpscripts umount
	@echo "Done BigCycle"

doall: prompt new remnt copyusb putkern syslin cpscripts uremnt
	@echo "Done doall"

# Test if promptless sudo works
testsudo:
	sudo echo "Message from non prompted SUDO"

# Callable from scripts, will not prompt (obsolete)

doall2: new2 remnt copyusb putkern syslin cpscripts uremnt
	@echo "Done doall"

burnusb:
	@sudo ./scripts/make_burnusb
	@make playsound

refresh:
	getkern getmods putmods putkern

prompt:
	@./scripts/prompt.sh " fdisk / format "
	@#echo "Prompt succeeded ..."

getusb:
	@sudo ./scripts/make_getusb

getusblite:
	@sudo ./scripts/make_getusb_lite

# ------------------------------------------------------------------------

remnt:
	./scripts/make_remount

uremnt:
	./scripts/make_uremount

# ------------------------------------------------------------------------
# Shortcuts  -- letter -> dependency

n:	new

u:	umount

c:	cycle

b:	bigcycle

a:	doall

# EOF
