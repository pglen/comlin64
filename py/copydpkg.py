#!/usr/bin/python

import os, sys, subprocess, shutil

#print("Hello")

#os.chdir("../comlin64-lite-000/lib/")

if  len(sys.argv) < 3:
    print("use: copydpkd.py package targdir")
    sys.exit()

if not os.path.isdir(sys.argv[2]):
    print("must use an existing dir for target")
    sys.exit(1)

res = subprocess.run(["dpkg",  "-L", sys.argv[1], ], capture_output=True)
#print("res", res)
if res.returncode:
    print(res.stderr.decode().strip())
    sys.exit(2)

full = res.stdout.decode().strip()

for aa in full.split("\n"):
    if os.path.isdir(aa):
        #print("dir", aa)
        if aa == "/." or aa == "/..":
            continue
        #npath = "." + os.sep + sys.argv[2] + aa
        npath = sys.argv[2] + aa
        #print("mkdir", npath)
        try:
            os.mkdir(npath)
        except FileExistsError:
            pass
        except:
            print("cannot create", aa, sys.exc_info())

    elif os.path.isfile(aa):
        #print("copy file", aa, npath)
        try:
            shutil.copy2(aa, npath)
        except:
            print("Cannot copy:", aa, sys.exc_info())
    else:
       print("misc", aa)


# EOF
