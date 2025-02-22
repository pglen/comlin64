#!/usr/bin/env python3

import time
import signal, os, sys
import logging, warnings
import re
import pam
import argparse

import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk
from gi.repository import Gdk
from gi.repository import GLib
from gi.repository import GObject
from gi.repository import Pango

import cairo

def get_disp_pos_size():

    warnings.simplefilter("ignore")
    disp2 = Gdk.Display()
    disp = disp2.get_default()
    #print( disp)
    scr = disp.get_default_screen()
    ptr = disp.get_pointer()
    mon = scr.get_monitor_at_point(ptr[1], ptr[2])
    geo = scr.get_monitor_geometry(mon)
    www = geo.width; hhh = geo.height
    xxx = geo.x;     yyy = geo.y
    warnings.simplefilter('default')

    return xxx, yyy, www, hhh

class xEntry(Gtk.Entry):

    def __init__(self, form, action = None):
        super(xEntry, self).__init__()
        self.form = form
        self.action = action
        self.connect("activate", self.enterkey)
        pass

    def enterkey(self, arg):
        #print("Enter:", self.get_text())
        if self.action:
            self.action()
        else:
            self.form.child_focus(Gtk.DirectionType.TAB_FORWARD)

def  microsleep(msec, flag = [0,]):

    if sys.version_info[0] < 3 or \
        (sys.version_info[0] == 3 and sys.version_info[1] < 3):
        timefunc = time.clock
    else:
        timefunc = time.process_time

    got_clock = timefunc() + float(msec) / 1000
    #print( got_clock)
    while True:
        if timefunc() > got_clock:
            break
        if flag[0]:
            break
        #print ("Sleeping")
        Gtk.main_iteration_do(False)

class MainWin(Gtk.Window):

    def __init__(self, conf = None):

        self.cnt = 0
        self.conf = conf
        self.stattime =  0
        self.busy = False

        Gtk.Window.__init__(self, type=Gtk.WindowType.TOPLEVEL)
        #Gtk.register_stock_icons()

        self.set_title("Please enter your user name and password:")
        self.set_position(Gtk.WindowPosition.CENTER_ALWAYS)
        self.set_events(Gdk.EventMask.ALL_EVENTS_MASK)

        self.set_decorated(False)
        self.wait_cursor = Gdk.Cursor(Gdk.CursorType.WATCH)
        self.hand_cursor = Gdk.Cursor(Gdk.CursorType.HAND2)
        self.regular_cursor = Gdk.Cursor(Gdk.CursorType.XTERM)

        #self.set_cursor_visible(True)

        #self.ic = Gtk.Image();
        #self.ic.set_from_file("icon.png")
        #self.pixbuf = self.ic.get_pixbuf()

        try:
            self.surface = cairo.ImageSurface.create_from_png('background.png')
        except:
            try:
                self.surface = cairo.ImageSurface.create_from_png('Utils/background.png')
            except:
                self.surface = None

        #ic.set_from_stock(Gtk.STOCK_DIALOG_INFO, Gtk.ICON_SIZE_BUTTON)
        #window.set_icon(ic.get_pixbuf())

        xx, yy, www, hhh = get_disp_pos_size()

        #self.set_default_size(4*www/8, 3*hhh/8)
        self.set_default_size(680, 300)

        self.set_app_paintable(True)

        self.connect("destroy", self.OnExit)
        self.connect("key-press-event", self.key_press_event)
        self.connect("key-release-event", self.key_release_event)
        self.connect('draw', self.expose)
        self.connect('map-event', self.done_map)
        self.connect('delete-event', self.delete)
        self.connect('motion-notify-event', self.motionx)

        try:
            self.set_icon_from_file("background.png")
        except:
            pass

        vbox = Gtk.VBox(); hbox = Gtk.HBox(); hbox2 = Gtk.HBox();

        self.up   = Gtk.Label(label="  ")
        self.down = Gtk.Label(label="   ")

        self.l1   = Gtk.Label(label="   ")
        self.l2   = Gtk.Label(label="   ")

        self.m1   = Gtk.Label(label="     ")
        self.m2   = Gtk.Label(label="     ")

        self.userL  = Gtk.Label.new_with_mnemonic(" _User Name:   ")
        self.userE  = xEntry(self)
        self.passL  = Gtk.Label.new_with_mnemonic(" Password:  ")
        self.passE  = xEntry(self, self.check_pass)
        self.passE.set_visibility(False)

        ddd = xconfig.get('defuser')
        if ddd:
            self.userE.set_text(ddd)
            self.set_focus(self.passE)

        vbox.pack_start(Gtk.Label(label="Please enter user name and password."), 0, 0, 6)
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
        #self.butt1 = Gtk.Button.new_with_mnemonic("   _Cancel  ")
        #self.butt2 = Gtk.Button.new_with_mnemonic("     _OK    ")

        #self.butt1.connect("clicked", self.cancel)
        #self.butt2.connect("clicked", self.ok)

        self.b1  = Gtk.Label(label="  ")
        self.b11 = Gtk.Label(label="             ")
        self.b2  = Gtk.Label(label="  ")
        self.m3  = Gtk.Label(label="  ")

        hbox2.pack_start(self.b1, 1, 1, 1)
        hbox2.pack_start(self.b11, 1, 1, 1)
        self.result = Gtk.Label(label="...")
        hbox2.pack_start(self.result, 0, 0, 1)
        #hbox2.pack_start(self.butt2, 0, 0, 1)
        hbox2.pack_start(self.m3, 0, 0, 1)

        #hbox2.pack_start(self.butt1, 0, 0,1)
        #hbox2.pack_start(self.b2, 0, 0, 1)

        vbox.pack_start(self.down, 1, 1, 0)
        vbox.pack_start(hbox2, 0, 0, 6)

        self.www, self.hhh =  self.get_size()

        self.add(vbox)
        self.show_all()

        aaa = xconfig.get('autologin')
        if aaa:
            GLib.timeout_add(40, self.autoexit)

    def autoexit(self):
        aaa = xconfig.get('autologin')

        if xconfig.get("verbose") > 0:
            print("Autologin for '%s' requested for" % aaa)

        self.result.set_text("Autologin for '%s' requested ..." % aaa)
        microsleep(20)
        time.sleep(1)

        self.save_result("/var/tmp/curruser", aaa)
        self.save_result("/var/tmp/currdisp", os.environ['DISPLAY'])

        if xconfig.get("pgdebug") > 2:
            print("destroy")
        self.destroy()

        if xconfig.get("pgdebug") > 2:
            print("onexit")
        self.OnExit(0)

    def motionx(self, widget, event):
        #print("motion", widget, event)
        if self.busy:
            print("Busy cursor", event)
            #self.get_window().set_cursor(self.wait_cursor)
        else:
            #self.get_window().set_cursor(self.wait_cursor)
            #self.get_window().set_cursor(self.regular_cursor)
            pass

    def key_press_event(self, arg1, arg2):
        #print("key press", arg1, arg2)
        pass

    def key_release_event(self, arg1, arg2):
        #print("key release", arg1, arg2)
        pass

    def ok(self, arg1):
        print("OK - user", self.userE.get_text(), self.passE.get_text())
        #self.OnExit(2)

    def cancel(self, arg1):
        #print("Cancel pressed", arg1)
        self.OnExit(1)

    def  OnExit(self, arg, arg2 = None):
        Gtk.main_quit()

    def check_pass(self):
        uu = self.userE.get_text();  pp = self.passE.get_text()

        if uu == "exit":
            sys.exit(1)

        if uu == "reboot":
            sys.exit(2)

        if uu == "shutdown":
            sys.exit(3)

        self.busy = True
        self.get_window().set_cursor(self.wait_cursor)

        if not uu or not pp:
            self.result.set_text("User / Pass fields cannot be empty.")
        else:
            self.result.set_text("Checking ...")
            microsleep(20)

            ret = pam.authenticate(uu, pp)
            if ret:
                self.result.set_text("Authenticated.")
                microsleep(20)
                time.sleep(.5)
                self.busy = False
                self.save_result("/var/tmp/curruser", uu)
                self.save_result("/var/tmp/currdisp", os.environ['DISPLAY'])
                sys.exit(0)

            else:
                self.result.set_text("Invalid credentials. Please try again ...")
                microsleep(20)

        microsleep(20)
        time.sleep(2)
        self.busy = False
        self.get_window().set_cursor(self.regular_cursor)
        self.result.set_text("")

        self.passE.set_text("")
        self.set_focus(self.userE)

    def expose (self, widget, cr):

        #print("Expose", widget, cr)
        ww, hh = self.get_size()

        if self.surface:
            cr.set_source_surface(self.surface)
            cr.paint()

        #cr.set_source_rgba(.8, .8, .8, 1)
        cr.set_source_rgba(.4, .4, .4, 1)
        cr.set_line_width(4)
        cr.move_to(0, 0);  cr.line_to(ww, 0)
        cr.move_to(ww, 0); cr.line_to(ww, hh)
        cr.move_to(ww, hh); cr.line_to(0, hh)
        cr.move_to(0, hh); cr.line_to(0, 0)
        cr.stroke()

        #cr.rectangle(0, 0, 0.9, 0.8)
        #cr.rectangle(4, 4, ww-8, hh-8)
        #cr.fill()

        #return True

    def save_result(self, fname, uu):
        try:
            fp = open(fname, "wt")
            fp.write(uu + "\n")
            fp.close()
        except:
            print("Error save file.", sys.exc_info())
            pass

        #sys.env

    def delete(self, widgetx, event):
        #print("Delete:", widgetx, event)
        return True

    def leave(self, widgetx, event):
        #print("Leave:", widgetx, event)
        #return True
        pass

    def done_map(self, widgetx, event):
        wnd = self.get_window()
        #self.get_window().set_cursor(self.regular_cursor)
        #self.get_window().set_cursor(self.wait_cursor)

        #curr = wnd.get_decorations()
        #print ("curr", curr)
        #print("resize", Gdk.WMDecoration.RESIZEH)
        #wnd.set_decorations(4)
        #self.grab_add()

        #Gdk.Device.grab(wnd, Gdk.GrabOwnership.NONE,
        #        False, Gdk.EventMask.ALL_EVENTS_MASK,
        #               None, None, Gdk.CURRENT_TIME)


def unbool(strx):

    ''' Un bool '''

    res = strx
    cmp = strx.lower()
    # Unquote
    if cmp[0] == "\"":
        cmp = cmp[1:-1]
    if cmp[0] == "\'":
        cmp = cmp[1:-1]

    # Try if number
    try:
       nnn = int(strx)
       res = nnn
    except:
        pass

    # Boolean strings
    if cmp  == "false":
        res = 0
    elif cmp  == "no":
        res = 0
    elif cmp  == "true":
        res = 1
    elif cmp  == "yes":
        res = 1

    return res

def parse(strx):

    state = 0; instr = 0
    bb = []
    str1 = ""; str2 = ""; comment = ""
    for aa in strx:
        if instr == 1:
            if aa == "\"":
                instr = 0
                #continue
            if state == 2:
                str2 += aa
            elif state == 0:
                str1 += aa
            else:
                pass
            continue
        if instr == 2:
            if aa == "\'":
                instr = 0
                #continue
            if state == 2:
                str2 += aa
            elif state == 0:
                str1 += aa
            else:
                pass
            continue
        if aa == "\"":
            instr = 1
            #continue
        if aa == "\'":
            instr = 2
            #continue
        if state == 0:
            if aa == "#":
                state = 1
                continue
            elif aa == "\"":
                instr = 1
                str1 += aa
                #continue
            elif aa == "=":
                state = 2
                continue
            else:
                if aa != " ":
                    str1 += aa

        elif state == 1:
            comment += aa
        elif state == 2:
            if aa == "#":
                state = 1
                continue
            if aa != " ":
                str2 += aa

    #if comment: print("comment:", comment)
    #if str1: print("str1:", str1)
    #if str2: print("str2:", str2)
    if str1: bb.append(str1)
    if str2: bb.append(str2)
    return bb

def readconf(xconfig):
    # Read config
    fpx = None
    try:
        fpx = open("/etc/pypass/pypass.conf", "rt")
    except:
        try:
            fpx = open("pypass.conf", "rt")
        except:
            print("Warn: no config, using defaults.")

    if fpx:
        conf = fpx.read()
        for aa in conf.split("\n"):
            if len(aa) == 0:
                continue
            #print("org:", aa)
            bb = parse(aa)
            if len(bb) == 0:
                continue
            if args.pgdebug > 3:
                print("parsed:", type(bb[1]), bb)
            #continue
            if len(bb) > 1:
                xconfig[bb[0]] = unbool(bb[1])
                if args.pgdebug > 3:
                    print(bb[1], type(xconfig[bb[0]] ))

            elif len(bb) > 0:
                xconfig[bb[0]] = 0
            else:
                pass

Version = "1.0.0"
pdesc = 'Simple login GUI. '
pform = "Use TAB or enter to navigate between fields and submit. " \
        "Use special user 'shutdown' for powering down system"

def main():

    global args, xconfig
    parser = argparse.ArgumentParser( description=pdesc, epilog=pform)

    parser.add_argument("-V", '--version', dest='version',
                        default=0,  action='store_true',
                        help='Show version number')

    parser.add_argument("-p", '--pconf', dest='pconf',
                        default=0,  action='store_true',
                        help='Print Configuration')

    parser.add_argument("-v", '--verbose', dest='verbose',
                        default=0,  action='count',
                        help='Verbose. Repeat -v for more information')

    parser.add_argument("-a", '--auto', dest='autologin', type=str,
                        default="",  action='store',
                        help='Auto log in user')

    parser.add_argument("-d", '--pgdebug', dest='pgdebug', type=int,
                        default=0,  action='store',
                        help='Show debug information')

    args = parser.parse_args()
    #print(args)

    if args.version:
        print("Version: %s" % Version)
        sys.exit(0)

    xconfig = {}
    readconf(xconfig)
    #merge the two:
    for key, val in vars(args).items():
        if not key in xconfig:
            xconfig[key] = val
        else:
            # override
            if val:
                xconfig[key] = val

    if args.pconf:
        for aa in xconfig:
            print(aa + " " * (14 - len(aa)), "=", xconfig[aa])
        sys.exit(0)

    #print(os.environ['DISPLAY'])
    mw = MainWin()
    Gtk.main()

if __name__ == '__main__':
    main()
    sus.exit(0)

# EOF
