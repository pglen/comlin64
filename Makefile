#
# Make a Community Linux ISO and jump drive
# Distributed under Community Linux Public License Version 1.0
#
# Notes:
#
#  Dangerous scripts. Make sure you are not partitionaing drives that
#  are in use, or drives that contain valuable data. Some rudimantary
#  checks are implemented, like refusing to partition a device
#  that is mounted on a system mount point. (/ /mnt /boot /home etc ...)
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
#  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
#  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
#  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
#  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

.PHONY: apps clean initramfs

# Unfortunately, most scripts need to access system stuff, so sudo
# is needed.

# If you want the lazy option, use ./py/crypter.py, and create a pass.
# Like: ./py/crypter.py -e yourpass > .crypted
#     optional: chmod go-rw .crypted (so it is user visible only)
# NOTE: this pass is medium secure, much better than plaintext pass ...
# ... delete after you are done. (rm .crypted)
# You can specify the crypter.py -key option (uses AES) to make it
# more secure, but ultimately chicken and egg will not allow
# this method to be really secure. For convenience only.

#SUDO=@echo ${shell ./py/crypter.py -i -d <.crypted} | sudo -n -S

# Else ... allow the sudo prompt as one normally would

#SUDO=sudo

all:
	@echo "Type 'make help' for a list of targets"

help:
	@echo
	@echo "Making a bootable jump drive. **(see Warning)"
	@echo
	@echo "	 	make makeiso    -- Make ISO and all dependents"
	@echo "	 	make detect     -- Configure which drive is your jump drive"
	@echo "	 	make new        -- & Fdisk / Format new usb"
	@echo "	 	make copyusb    -- & @ Copy LINUX files to USB drive "
	@echo "	 	make putkern    -- & @ * Copy kernel from build dir to USB"
	@echo "	 	make syslin     -- & @ * Install syslinux to USB"
	@echo "	 	make apps       -- & @ * Make support apps"
	@echo "	 	make umount     -- & @ * Unmount USB drives"
	@echo "	 	make cycle      --  Do all denoted by '*'"
	@echo "	 	make bigcycle   --  Do all denoted by '@'"
	@echo "	 	make doall      --  Do all denoted by '&'"
	@echo
	@echo "   For more information type 'make help2'"
	@echo
	@echo " **Warning! Make sure config_build:RDDEV points to a jump drive!"
	@echo "      !!!! Specifying the wrong drive will destroy data !!!! "
	@echo

help2:
	@echo
	@echo "Making a bootable jump drive. *(see Warning! at end)"
	@echo
	@echo "Development / sys:"
	@echo
	@echo "	 	make cycle       -- run putkern->syslinux->unmount"
	@echo "	 	make getusb      -- get USB content back to project"
	@echo "	 	make getusblite  -- get USB lite content back to project"
	@echo "	 	make getusb2     -- update from USB content back to project"
	@echo "	 	make copy        -- to mirror current system to USB (advanced)"
	@echo "	 	make initramfs      -- to make a new initramfs"
	@echo "	 	make putmods     -- Copy modules from build dir to USB"
	@echo "	 	make refresh     -- Refresh kernel (System->Build_dir->USB)"
	@echo
	@echo "   For more information type 'make help3'"
	@echo
	@echo " *Warning! Make sure config_build:RDDEV points to a jump drive!"
	@echo "      !!!! Specifying the wrong drive will destroy data !!!! "
	@echo

help3:
	@echo
	@echo "Making a bootable jump drive. *(see Warning! at end)"
	@echo
	@echo "Shortcuts:"
	@echo
	@echo "	 	make c            -- alias for make cycle"
	@echo "	 	make u            -- alias for make umount"
	@echo "	 	make n            -- alias for make new"
	@echo "	 	make b            -- alias for make bigcycle"
	@echo "	 	make a            -- alias for make doall"
	@echo
	@echo "Preparation: (optional)"
	@echo
	@echo "	 	make getmods    -- Copy modules from system into build dir"
	@echo "	 	make getmods2   -- Copy modules from system into USB build dir"
	@echo "	 	make getkern    -- Copy kernel from system into build dir"
	@echo "	 	make getkern2   -- Copy kernel from system into USB dir"
	@echo "	 	make clean      -- Remove tmp and work files"
	@echo
	@echo "   For more information type 'make help4'"
	@echo
	@echo " *Warning! Make sure config_build:RDDEV points to a jump drive!"
	@echo "      !!!! Specifying the wrong drive will destroy data !!!! "
	@echo

help4:
	@echo
	@echo "Making a bootable jump drive. (see Warning! at end)"
	@echo
	@echo "To execute the whole set of commands in a batch operation:"
	@echo
	@echo "	 	su root -c 'make doall'"
	@echo
	@echo "The 'su' command will not timeout like the sudo for the long "
	@echo "copy process;"
	@echo
	@echo "The 'make doall2' target will not promp for confirmation. Mainly"
	@echo "useful for scripts"
	@echo
	@echo "	 	make getimg     -- Get COMLIN drive image"
	@echo
	@echo " *Warning! Make sure config_build:RDDEV points to a jump drive!"
	@echo "      !!!! Specifying the wrong drive will destroy data !!!! "
	@echo

apps:
	make -s -C apps apps

prompt:
	@./scripts/prompt.sh " fdisk / format "
	@#echo "Prompt succeeded ..."

detect:
	sudo ./scripts/make_detect

new: prompt
	sudo ./scripts/make_part go
	sudo ./scripts/make_fs go
	@echo "Remove and Reinsert drive for next steps"

new2:
	sudo ./scripts/make_part go
	sudo ./scripts/make_fs go

initramfs:
	@sudo ./scripts/make_initramfs

checkscripts:
	@sudo ./scripts/make_check_scripts

bootimage:
	@sudo ./scripts/make_toritoimage

cdboot:
	@sudo ./scripts/make_cdboot

getusb:
	@sudo ./scripts/make_getusb

getusblite:
	@sudo ./scripts/make_getusb_lite

getusb2:
	@sudo ./scripts/make_getusb -u

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

# This is the 64 bit make all
buildiso: apps checkscripts initramfs prepiso getapps iso
	@play Oxygen-Sys-App-Message.ogg >/dev/null 2>&1
	@#play bell.ogg >/dev/null 2>&1

# Test if sound plays
playif:
	@#play bell.ogg >/dev/null 2>&1 &
	@play Oxygen-Sys-App-Message.ogg >/dev/null 2>&1

# Test if sudo promptless works
testsudo:
	sudo echo "Message from non prompted SUDO"

# Callable from scripts, will not prompt (obsolete)

doall2: new2 remnt copyusb putkern syslin cpscripts uremnt
	@echo "Done doall"

# ------------------------------------------------------------------------

remnt:
	./scripts/make_remount

uremnt:
	./scripts/make_uremount

getkern:
	@sudo ./scripts/make_getkern

getboot:
	@sudo ./scripts/make_getboot

getkern2:
	@sudo ./scripts/make_getkern2

getapps:
	@sudo ./scripts/make_getapps

getmods:
	@sudo ./scripts/make_getmods

getmods2:
	@sudo ./scripts/make_getmods2

putmods:
	@sudo ./scripts/make_putmods

putkern:
	@sudo ./scripts/make_putkern go

refresh:	getkern getmods putmods putkern

umount:
	@echo "Wait for USB drive inactivity. Then you may remove drive."

cpscripts:
	@sudo ./scripts/make_cpscripts

iso:
	@sudo ./scripts/make_iso

prepiso:
	@sudo ./scripts/make_prepiso

# ------------------------------------------------------------------------

backup:
	@sudo ./backup.sh

pack:
	@sudo ./pack.sh

clean:
	make -s -C apps clean
	@sudo ./scripts/make_clean

getimg:
	@sudo ./scripts/make_getimg

# ------------------------------------------------------------------------
# Shortcuts for PG  letter -> dependency

n:	new

u:	umount

c:	cycle

b:	bigcycle

a:	doall

git:
	git add .
	git commit -m "Auto Checkin"
	git push

# End of Makefile







