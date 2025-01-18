#!/bin/bash

# File monitor
# Testing ....

#  Monitor /etc/initrc -- fake init daemon

#inotifywait -q -r -m -e modify /etc/initrc |
inotifywait -q -r -m -e open -r / #initrc

while read file_path file_event file_name; do
   echo ${file_path} ${file_name} event: ${file_event}
done

