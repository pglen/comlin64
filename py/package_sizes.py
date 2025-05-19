#!/usr/bin/python

import os, sys, subprocess, re
from argparse import ArgumentParser

version = "1.0"

def     cmdline():

    parser = ArgumentParser( \
        description="Encrypt / Decrypt command line argument to stdout.",
        epilog="One of encrypt / decrypt option needs to be specified.")


    parser.add_argument("-v", "--verbose",
                  action="store_true", dest="verbose",
                  help="Print extended status messages to stdout")

    parser.add_argument("-V", "--vesion",
                  action="store_true", dest="version",
                  help="Print version to stdout")

    return parser


def sys_run(comm, *args):

    if clargs.verbose:
        print("Exec:", comm, args)

    res = subprocess.run([comm,  *args,], capture_output=True)
    full = res.stdout.decode().strip()
    return full

if __name__ == '__main__':

    #print("Crypter")
    parser = cmdline(); clargs = parser.parse_args()
    #print(clargs)

    if clargs.version:
        print("Version: %s" % version)
        sys.exit(1)
    ret = sys_run("apt", "list", "--installed")
    for aa in ret.split("\n"):
        bb = aa.split("/")
        #print(bb[0])
        cc = sys_run("apt", "show", bb[0])
        for dd in cc.split("\n"):
            #print(dd)
            iii = "Installed-Size:"
            if dd.find(iii) >= 0:
                # convert number
                num = dd[len(iii):].split()
                mult = 1
                nnn = float(num[0].replace(",", ""))
                uuu = num[1].upper()
                if uuu.find("MB") >= 0:
                    mult = 1000000
                elif uuu.find("KB") >= 0:
                    mult = 1000
                else:
                    mult = 1

                #print (num, nnn, uuu, mult, end = " ")
                print("%.0f" % (nnn * mult), "\t", bb[0])

# EOF
