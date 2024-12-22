#!/bin/bash

trap "echo; echo hello sigint" SIGINT
./keyget "Testing keyget. Press Ctrl-C to shortcut, Enter to Stop"
echo "Got: $?"


