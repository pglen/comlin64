#!/usr/bin/python

import os, sys

print("Hello")

#peterglen@dell007:~/pgsrc/comlin/comlin64-lite-000

#os.chdir("../comlin64-lite-000/lib/x86_64-linux-gnu/")
os.chdir("../comlin64-lite-000/lib/")

dd = os.listdir(".")

#print("listdir" , dd)

for aa in dd:
    bb = aa.split(".")
    if len(bb) > 3:
        #print("aa =", aa, "bb =", bb)
        nnn = ".".join(bb[:3])
        #print("from:", aa, "to:", nnn)
        os.rename(aa, nnn)