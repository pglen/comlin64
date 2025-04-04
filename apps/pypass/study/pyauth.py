#!/usr/bin/env python

import os, sys
import PAM
from getpass import getpass


#!/usr/bin/env python3

import os, sys, getopt, signal, select, socket, time, struct
import random, stat

import  pyvpacker

import gettext
gettext.bindtextdomain('thisapp', './locale/')
gettext.textdomain('thisapp')
_ = gettext.gettext

base = os.path.dirname(os.path.realpath(__file__))
sys.path.append(os.path.join(base))
sys.path.append(os.path.join(base,  'pyspass'))

try:
    from pyspass import pgutil
except:
    # Global
    sys.path.append(os.path.join(base,  '..', 'pyspass'))
    from pyspass import pgutil

from pyspass import mainwin
from pyspass import pgpasql

# ------------------------------------------------------------------------
# Globals

# Version of the program
version = "0.50"

# ------------------------------------------------------------------------

def phelp():

    print()
    print( "Usage: " + os.path.basename(sys.argv[0]) + " [options]")
    print()
    print( "Options:    -d level  - Debug level 0-10")
    print( "            -r dir    - Document root")
    print( "            -v        - Verbose")
    print( "            -V        - Version")
    print( "            -q        - Quiet")
    print( "            -h        - Help")
    print()
    sys.exit(0)

# ------------------------------------------------------------------------
def pversion():
    print( os.path.basename(sys.argv[0]), "Version", version)
    sys.exit(0)

    # option, long_option,  var_name,   initial_value, function
optarrlong = \
    ["d:",    "debug",       "pgdebug",  0,                 None],      \
    ["r:",    "docroot",     "docroot",  "~/.pyspass",      None],      \
    ["f:",    "file",        "file",     "passdata.sqlt",   None],      \
    ["v",     "verbose",     "verbose",  0,                 None],      \
    ["q",     "quiet",       "quiet",    0,                 None],      \
    ["V",     "version",     None,       None,              pversion],  \
    ["h",     "help",        None,       None,              phelp],     \

conf = pgutil.ConfigLong(optarrlong)

def mainfunc():

    args = conf.comline(sys.argv[1:])
    if conf.err:
        print(conf.err)
        sys.exit(1)
    if conf.pgdebug > 6:
        conf.printvars()
    basedir = os.path.expanduser(conf.docroot)
    if not os.path.isdir(basedir):
        if conf.pgdebug > 2:
            print("Make dir", basedir)
            os.mkdir(basedir)

    os.chdir(basedir)

    pgsql = pgpasql.pgpasql("passdata.sqlt")
    mw = mainwin.MainWin(pgsql, conf.pgdebug)
    mw.verbose = conf.verbose
    mw.run()
    sys.exit(0)

if __name__ == '__main__':
    mainfunc()

# EOF


