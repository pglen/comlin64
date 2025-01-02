#!/usr/bin/python

import os, sys, subprocess

xutils = ["cp", "dmesg", "Xorg"]

#print("getutil")

for aa in xutils:
    res = subprocess.run(["which",  aa,], capture_output=True)
    full = res.stdout.decode().strip()

    resx = subprocess.run(["stat",  "-c", "%F %N" , full,], capture_output=True)
    resx2 = resx.stdout.decode().strip()
    print("stat: '%s'" % resx2)

    print("'%s'" % full)
    res2 = subprocess.run(["ldd",  full], capture_output=True)
    libs = res2.stdout.decode()
    lll = libs.splitlines()
    cnt = 0
    for bb in lll:
        items = bb.split()
        if len(items) < 3:
            continue
        print("%s:" % aa,  items[0], "\t",items[2])
        cnt += 1
# EOF
