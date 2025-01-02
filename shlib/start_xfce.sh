#!/bin/bash

# Log errors, switch back to terminal 1

#echo Starting Xfce
startxfce4 >~/xfce_log 2>~/xfce_errlog
#echo Xfce ended.

chvt 1

# EOF