# Make file include

help1:
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
	@echo
	@echo "      !!!! Specifying the wrong drive will destroy data !!!! "
	@echo

# EOF
