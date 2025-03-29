# Makefile

.PHONY: apps clean

all:
	make -C keyget
	make -C reboot
	make -C notify
	make -C empty
	make -C zombie
	make -C MessageBox-X11


#make -C hello

help:
	@echo "Targets: apps help clean"

clean:
	make -C keyget clean
	make -C reboot clean
	make -C empty clean
	make -C notify clean
	make -C zombie clean
	make -C MessageBox-X11 clean

# EOF
