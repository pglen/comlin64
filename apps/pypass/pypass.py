#!/usr/bin/env python

import time
import signal, os, time
import logging

import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk
from gi.repository import Gdk
from gi.repository import GLib
from gi.repository import GObject
from gi.repository import Pango

class MainWin(Gtk.Window):

    def __init__(self, conf = None):

        self.cnt = 0
        self.conf = conf
        self.stattime =  0

        Gtk.Window.__init__(self, Gtk.WindowType.TOPLEVEL)
        #Gtk.Window.__init__(self, Gtk.WindowType.POPUP)
        #self = Gtk.Window(Gtk.WindowType.TOPLEVEL)
        #Gtk.register_stock_icons()

        self.set_title("Please enter your user name and password")
        self.set_position(Gtk.WindowPosition.CENTER_ALWAYS)

        #ic = Gtk.Image(); ic.set_from_stock(Gtk.STOCK_DIALOG_INFO, Gtk.ICON_SIZE_BUTTON)
        #window.set_icon(ic.get_pixbuf())

        www = Gdk.Screen.width(); hhh = Gdk.Screen.height();

        disp2 = Gdk.Display()
        disp = disp2.get_default()
        #print( disp)
        scr = disp.get_default_screen()
        ptr = disp.get_pointer()
        mon = scr.get_monitor_at_point(ptr[1], ptr[2])
        geo = scr.get_monitor_geometry(mon)
        www = geo.width; hhh = geo.height
        xxx = geo.x;     yyy = geo.y

        # Resort to old means of getting screen w / h
        if www == 0 or hhh == 0:
            www = Gdk.screen_width(); hhh = Gdk.screen_height();

        #self.set_default_size(4*www/8, 2*hhh/8)

        self.connect("destroy", self.OnExit)
        self.connect("key-press-event", self.key_press_event)
        self.connect("key-release-event", self.key_release_event)
        #self.connect("button-press-event", self.button_press_event)

        try:
            self.set_icon_from_file("icon.png")
        except:
            pass

        vbox = Gtk.VBox(); hbox = Gtk.HBox(); hbox2 = Gtk.HBox();

        self.up   = Gtk.Label(label="  ")
        self.down = Gtk.Label(label="   ")

        self.l1   = Gtk.Label(label="   ")
        self.l2   = Gtk.Label(label="   ")

        self.m1   = Gtk.Label(label="     ")
        self.m2   = Gtk.Label(label="     ")

        self.userL = Gtk.Label(label=" User:   ")
        self.userE  = Gtk.Entry()
        self.passL = Gtk.Label(label=" Password:  ")
        self.passE  = Gtk.Entry()

        vbox.pack_start(self.up, 1, 1, 0)

        grid = Gtk.Grid()
        grid.set_row_spacing(4)

        grid.attach(self.userL, 1, 0, 1, 1)
        grid.attach(self.userE, 2, 0, 1, 1)
        grid.attach(self.m1,    3, 0, 1, 1)
        grid.attach(self.passL, 4, 0, 1, 1)
        grid.attach(self.passE, 5, 0, 1, 1)

        hbox.pack_start(self.l1,    1, 1, 1)
        hbox.pack_start(grid,       0, 0, 1)
        hbox.pack_start(self.l2,    1, 1, 1)

        vbox.pack_start(hbox, 0, 0, 6)
        self.butt1 = Gtk.Button.new_with_mnemonic("   _Cancel  ")
        self.butt2 = Gtk.Button.new_with_mnemonic("     _OK    ")

        self.butt1.connect("activate", self.cancel)
        self.butt2.connect("activate", self.ok)

        self.b1 = Gtk.Label(label="  ")
        self.b2 = Gtk.Label(label="  ")
        self.m3 = Gtk.Label(label="  ")

        hbox2.pack_start(self.b1, 1, 1, 1)
        hbox2.pack_start(self.butt2, 0, 0, 1)
        hbox2.pack_start(self.m3, 0, 0, 1)
        hbox2.pack_start(self.butt1, 0, 0,1)
        hbox2.pack_start(self.b2, 0, 0, 1)

        vbox.pack_start(hbox2, 0, 0, 6)

        #vbox.pack_start(self.down, 1, 1, 0)

        self.add(vbox)
        self.show_all()

    def key_press_event(self, arg1, arg2):
        #print("key", arg1, arg2)
        pass

    def key_release_event(self, arg1, arg2):
        #print("key release", arg1, arg2)
        pass

    def ok(self, arg1):
        print("OK pressed", arg1)
        self.OnExit(2)

    def cancel(self, arg1):
        print("Cancel pressed", arg1)
        self.OnExit(1)

    def  OnExit(self, arg, arg2 = None):
        Gtk.main_quit()


def main():
    mw = MainWin()
    Gtk.main()

if __name__ == '__main__':
    main()


