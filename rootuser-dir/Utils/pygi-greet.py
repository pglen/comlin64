#!/usr/bin/env python3

import os, sys, getopt, signal, random, time, warnings

import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk
from gi.repository import Gdk
from gi.repository import GLib
from gi.repository import GObject
from gi.repository import Pango
from gi.repository import GLib

def go_away():
    Gtk.main_quit()

ww = Gtk.Window()
ww.set_position(Gtk.WindowPosition.CENTER_ALWAYS)
ww.set_size_request(500, 200)
ww.connect("delete-event", Gtk.main_quit)
ww.connect("destroy", Gtk.main_quit)
lab = Gtk.Label(label="Starting ComLin64, Please Wait ...")
fd = Pango.FontDescription("Arial 20")
lab.override_font(fd)

ww.add(lab)
ww.show_all()

GLib.timeout_add(3000, go_away)

Gtk.main()

# EOF
