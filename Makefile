#
# Make a Community Linux 64 ISO and USB drive
# Distributed under Community Linux 64 Public License Version 1.0
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

SOUND = sounds/longbell.ogg
SOUND2 = sounds/bell.ogg
SOUND3 = sounds/trash-empty.oga

SILENT = 0

all:
	@echo "Type 'make help' for a list of targets"

# Pushed old content to includes

include help.mk
#include legacy.mk

help:
	@echo
	@echo "Making a bootable jump drive. Use it with care."
	@echo
	@echo "  make detect       -- Configure which drive is your jump drive"
	@echo "  make buildsys     -- Assemble system components and it's dependents"
	@echo "  make craftiso     -- Make .ISO file"
	@echo "  make newusb       -- New USB, Partition/Format/GRUB USB drive"
	@echo "  make updateusb    -- Copy/Update Linux files onto USB"
	@echo "  make createusb    -- Make new USB, and Copy Linux files to USB"
	@echo
	@echo "	 make newcleanusb  -- Partition/Clean/Format/GRUB USB !SLOW!"
	@echo
	@echo " Use: make help[1-4] to show more help details. (obsolete)"
	@echo
	@echo "**see additional Warning(s) in Makefile"
	@echo

apps:
	make -s -C apps

detect:
	sudo ./scripts/make_detect

initramfs: apps
	@sudo ./scripts/make_initramfs

checkscripts:
	@sudo ./scripts/make_check_scripts

doiso: buildsys
	@sudo ./scripts/make_iso
	@make playsound

# This is the 64 bit make all
buildsys: apps checkscripts initramfs prepiso prepdown getapps
	@make playsound2

createusb: buildsys
	@cd grub-data ; ./do_new.sh
	@cd grub-data ; ./do_sys.sh

updateusb:  buildsys
	@#sudo ./scripts/make_prepiso
	@cd grub-data ; ./do_sys.sh
	@make playsound

newusb:
	@cd grub-data ; ./do_new.sh

newcleanusb:
	@cd grub-data ; ./do_new.sh -c

# Test if sound plays
ifeq (${SILENT},0)

playsound:
	@play ${SOUND} >/dev/null 2>&1 &
# Somewhat more friedly (quiet) sound
playsound2:
	@play  ${SOUND2} >/dev/null 2>&1 &

# Somewhat more harsh for error
playsound3:
	@play  ${SOUND3} >/dev/null 2>&1 &
else

playsound:
	@echo "Not playing 1."
playsound2:
	@echo "Not playing 2."
playsound3:
	@echo "Not playing 3."
endif

getkern:
	@sudo ./scripts/make_getkern

getboot:
	@sudo ./scripts/make_getboot

getkern2:
	@sudo ./scripts/make_getkern2

getapps:  apps
	@sudo ./scripts/make_getapps

getmods:
	@sudo ./scripts/make_getmods

getmods2:
	@sudo ./scripts/make_getmods2

putmods:
	@sudo ./scripts/make_putmods

putkern:
	@sudo ./scripts/make_putkern go

umount:
	@echo "Wait for USB drive inactivity. Then you may remove drive."

cpscripts:
	@sudo ./scripts/make_cpscripts

makeiso:
	@sudo ./scripts/make_iso

prepiso:  getapps
	@sudo ./scripts/make_prepiso

prepdown:
	@sudo ./scripts/make_shutdown

# ------------------------------------------------------------------------
# Backup / Packing / Management

backup:
	@sudo ./backup.sh

pack:
	@sudo ./pack.sh

clean:
	make -s -C apps clean
	@sudo ./scripts/make_clean

getimg:
	@sudo ./scripts/make_getimg

git:
	git add .
	git commit -m "Auto Checkin"
	git push

# End of Makefile







