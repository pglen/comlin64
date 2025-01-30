# Makefile

.PHONY: apps clean

all:
	@echo "Help: make help for more info"

help:
	@echo "Targets: apps help clean"

apps:
	make -C keyget keyget
	make -C reboot
	make -C empty
	make -C MessageBox-X11

clean:
	make -C keyget clean
	make -C reboot clean
	make -C empty clean
	make -C MessageBox-X11 clean

# EOF
