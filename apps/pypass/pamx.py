#!/usr/bin/env python

import os, sys
import pam
#print(dir(pam))

ret = pam.authenticate("peterglen", "kitty1357")
print(ret)
sys.exit(ret)

# EOF
