#!/bin/bash
# Just signal what the user wanted

echo $0 $@ > /var/tmp/.shutdowncmd

# EOF