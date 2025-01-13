#!/usr/bin/env python

# Encrypt a string to / from command argument

import os, sys, glob, getopt, time, base64
import string, signal, stat, shutil, resource

from argparse import ArgumentParser

from Crypto.Cipher import AES

version = "1.0"
keyx    = b"0123456789123456"
noncex  = b"12345678"

def     cmdline():

    parser = ArgumentParser( \
        description="Encrypt / Decrypt command line argument to stdout.",
        epilog="One of encrypt / decrypt option needs to be specified.")

    parser.add_argument('strx', metavar='strx',  nargs='*',
                    help='The strings to encrypt')

    parser.add_argument("-v", "--verbose",
                  action="store_true", dest="verbose",
                  help="Print extended status messages to stdout")

    parser.add_argument("-V", "--vesion",
                  action="store_true", dest="version",
                  help="Print version to stdout")

    parser.add_argument("-q", "--quiet",
                  action="store_true", dest="quiet",
                  help="Do not print status messages to stdout")

    parser.add_argument("-g", "--debug",
                  action="store_true", dest="debug",
                  help="Print debug info (no-op)")

    parser.add_argument("-e", "--encrypt",
                  action="store_true", dest="encrypt",
                  help="Encrypt the command line string")

    parser.add_argument("-d", "--decrypt",
                  action="store_true", dest="decrypt",
                  help="Decrypt the command line string")

    parser.add_argument("-i", "--stdin",
                  action="store_true", dest="stdin",
                  help="Read Decrypt data from stdin")

    parser.add_argument("-k", "--key",
                  action="store", dest="key",
                  help="Key to use. Padded to len=16. Default: 0,1,2..")

    return parser

def badpass():
    print("Invalid pass.", file=sys.stderr)
    if clargs.verbose:
        print(sys.exc_info(), file=sys.stderr)

    sys.exit(1)

# ------------------------------------------------------------------------
# Start of program:

if __name__ == '__main__':

    #print("Crypter")
    parser = cmdline(); clargs = parser.parse_args()
    #print(clargs)

    if clargs.version:
        print("Version: %s" % version)
        sys.exit(1)

    if len(clargs.strx) < 1 and not clargs.stdin:
        print("Must specify string.", file=sys.stderr)
        sys.exit(1)

    if clargs.key:
        lenx = len(clargs.key)
        if lenx < 16:
            keyx = clargs.key + '0' * (16 - lenx)
        else:
            keyx = clargs.key[:16]
        keyx = bytes(keyx, 'utf-8')

    #if clargs.verbose:
    #    print("keyx %s" % keyx)

    if clargs.stdin:
        buff = sys.stdin.read()
    else:
        buff = "".join(clargs.strx)

    buff = bytes(buff, "utf-8")
    #print("buff", buff, file=sys.stderr)

    cipher = AES.new(keyx, AES.MODE_CTR,
                        use_aesni=True,
                        nonce = noncex)

    res = ""
    if clargs.encrypt:
        buff = cipher.encrypt(buff)
        res = base64.b64encode(buff)
    elif clargs.decrypt:

        try:
            buff = base64.b64decode(buff)
        except:
            badpass()

        res = cipher.decrypt(buff)
    else:
        print("Must specify Encrypt or Decrypt operation.", file=sys.stderr)
        sys.exit(2)

    try:
        sss = res.decode()
    except:
        badpass()

    print(sss)

# EOF
