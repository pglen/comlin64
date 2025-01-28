# use "gcc" to compile source files.
CC = gcc
# the linker is "g++". It might be something else with other compilers.
LD = g++
# Compiler flags go here.
CFLAGS = -O2 -Wall -fno-delete-null-pointer-checks
# Linker flags go here.
LDFLAGS = 
# use this command to erase files.
RM = /bin/rm -f
#
MKDIR=/bin/mkdir
# list of generated object files.
OBJS = main.o
# program executable file name.
PROG = beesu
# install
INSTALL=install

# FEDORA RELATED FOLDERS:
DESTDIR?=
MANDIR=$(DESTDIR)/usr/share/man
BINDIR=$(DESTDIR)/usr/bin
SBINDIR=$(DESTDIR)/usr/sbin
CONFDIR=$(DESTDIR)/etc
CONSOLEHELPER=consolehelper



# top-level rule, to compile everything.
all: $(PROG)

# rule to link the program
$(PROG): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $(PROG)

# rule for file "main.o".
main.o: main.c
	$(CC) $(CFLAGS) -c main.c

# rule for cleaning re-compilable files.
clean:
	$(RM) $(PROG) $(OBJS)

# To install things in the right place
install:
	$(MKDIR) -v -p $(SBINDIR)
	$(MKDIR) -v -p $(BINDIR)
	$(MKDIR) -v -p $(CONFDIR)
	$(MKDIR) -v -p $(CONFDIR)/pam.d
	$(MKDIR) -v -p $(CONFDIR)/security/console.apps
	$(MKDIR) -v -p $(CONFDIR)/profile.d
	$(MKDIR) -v -p $(MANDIR)/man1
	$(INSTALL) -p -m 755 $(PROG) $(SBINDIR)
	$(INSTALL) -p -m 644 pam.d/$(PROG) $(CONFDIR)/pam.d
	$(INSTALL) -p -m 644 console.apps/$(PROG) $(CONFDIR)/security/console.apps
	$(INSTALL) -p -m 644 beesu.conf $(CONFDIR)
	$(INSTALL) -p -m 644 $(PROG).1.gz $(MANDIR)/man1
	$(INSTALL) -p -m 644 profile.d/$(PROG)-bash-completion.sh $(CONFDIR)/profile.d
	ln -s $(CONSOLEHELPER) $(BINDIR)/$(PROG)


# uninstall
uninstall:
	$(RM) $(CONFDIR)/pam.d/$(PROG)
	$(RM) $(CONFDIR)/security/console.apps/$(PROG)
	$(RM) $(SBINDIR)/$(PROG)
	$(RM) $(BINDIR)/$(PROG)
	$(RM) $(CONFDIR)/beesu.conf
	$(RM) $(MANDIR)/man1/$(PROG).1.gz
	$(RM) $(CONFDIR)/profile.d/$(PROG)-bash-completion.sh


