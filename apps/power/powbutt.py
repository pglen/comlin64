#!/usr/bin/python3

import subprocess

import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk
from gi.repository import Gdk
from gi.repository import GLib
from gi.repository import GObject
from gi.repository import Pango

import dbus
from dbus.mainloop.glib import DBusGMainLoop

found  = 0
device = ""

def action(*args):

    # Filter out non string arguments
    if len(args) == 0:
        print("empty")
        return

    print("callb", *args)

    if type(args[0]) != dbus.String and type(args[0]) != dbus.ObjectPath:
        #print " not string ", type(args[0]), args[0]
        return

    # Handle power button:
    if len(args) == 2 and args[0] == "ButtonPressed" and args[1] == "power":
        # The action to perform when the power button is pressed
        print("Power button pressed!")
        subprocess.call(["/usr/bin/python3", "/bin/ctrlt_del.py"]);

    # Handle lid:
    if len(args) == 2 and args[0] == "ButtonPressed" and args[1] == "lid":
        # The action to perform when the power button is pressed
        print("Lid closed!", args)
        #subprocess.call(["/usr/bin/python", "/apps/power/ctrl_alt_del.py"]);

def main():
    # Initialize the event loop
    DBusGMainLoop(set_as_default=True)

    # Connect to the System DBUS
    system_bus = dbus.SystemBus()

    # Declare an interest in DBUS signals
    system_bus.add_signal_receiver(action)

    print("Started listening")
    # Wait for events
    #GObject.MainLoop().run()
    GLib.MainLoop().run()

if __name__ == '__main__':
    main()
    sys.exit(0)

# EOF
