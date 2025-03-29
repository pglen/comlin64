#
# We created two excutables, following Linux tradition. In the origianl
# implementation, these are symlinks to one excutable, but we are keeping it simple.
#

all: powacpi sendacpi

powacpi: powacpi.c
	gcc powacpi.c  -o powacpi

sendacpi: sendacpi.c
	gcc sendacpi.c  -o sendacpi

clean:
	rm -f powacpi *.o

# EOF
