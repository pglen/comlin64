import os, sys
from elevate import elevate

print("ele", dir(elevate))

#sys.exit(0)

def is_root():
    return os.getuid() == 0

print("before ", is_root())
elevate()
print("after ", is_root())
