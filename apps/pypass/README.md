# README

 This a replacement login utility.

## Configuration

File: /etc/pypass/pypass.conf

    Pypass Config
    SYNTAX: key = value
    Comments after hash '#' charater till end of line
    Strings are delimited by " " or ' '

Boolean values:

    Yes|yes|YES|True|true|TRUE is 1
    No|no|NO|False|false|FALSE is 0

Keys / Values:

    defuser = user          Fill in default user into text box
    autologin = user        Auto login as that user
    autoexec = program      Run program on startup

    verbose = 0             Show running info (0=none -v=info)
    pgdebug = 3             Debug level (0=none 1...10)

Run program on startup.

    The program is executed on the bash shell. Use '&' to
    execute more than one program. Example: proram1 & program2

## Features:

   o Simple operation
   o Hot key options

## Security

  The 'Login' display animates slowly, to show that this
dialog is authentic.

## Usage information

usage: pypass.py [-h] [-V] [-p] [-v] [-a AUTOLOGIN] [-e EXEC] [-d PGDEBUG]

Simple login GUI.

options:
  -h, --help            show this help message and exit
  -V, --version         Show version number
  -p, --pconf           Print Configuration
  -v, --verbose         Verbose. Repeat -v for more information
  -a AUTOLOGIN, --auto AUTOLOGIN
                        Auto log in user
  -e EXEC, --exec EXEC  Auto exec program.
  -d PGDEBUG, --pgdebug PGDEBUG
                        Show debug information

Use TAB or enter to navigate between fields and submit. Use special user
'shutdown' for powering down system

// EOF