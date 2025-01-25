#!/bin/bash

### Uncomment either the zenity or yad command

#ans=$(zenity  --title "Save With Exit" --height 300 --width 200 \
#                --list  --text "Log Out: $USER" --radiolist  \
#                --column " " --column "Method" TRUE \
#                Logout FALSE Shutdown FALSE Reboot FALSE \
#                Suspend FALSE Hibernate FALSE "Lock Screen" FALSE "Reboot Kubuntu")

ans=$(yad   --window-icon=system-devices-panel-information \
            --on-top --sticky --fixed --center --width 200 \
            --entry --title "Xfce Exit" --text "\nSelect an action:\n" \
            --image=xfce4_xicon3 --image-on-top --button="gtk-ok:0" \
            --button="gtk-cancel:1" --text-align center \
            --entry-text  "Power Off" "Reboot" "Logout" )
            #--entry-text  "Logout" "Reboot" "Suspend" "Hibernate" \
            #        "Power Off" "Lock Screen" "Reboot Kubuntu")
            #"Suspend" "Hibernate" "Lock Screen")

[[ $ret -eq 1 ]] && exit 0

case $ans in
	Logout*)
		xfce4-session-logout -l
	;;
	Power*)
		xfce4-session-logout -h
	;;
	Reboot)
		xfce4-session-logout -r
	;;
	Suspend*)
		xfce4-session-logout -s
	;;
	Hibernate*)
		xfce4-session-logout --hibernate
	;;
    	Lock*)
        	xflock4
	;;
	Reboot\ Kubuntu)
		sudo grub-reboot "Kubuntu"
		xfce4-session-logout -r
    	;;
	*)
	;;
esac
exit 0
