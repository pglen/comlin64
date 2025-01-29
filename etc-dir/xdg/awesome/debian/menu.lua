-- automatically generated file. Do not edit (see /usr/share/doc/menu/html)

local awesome = awesome

Debian_menu = {}

Debian_menu["Debian_Applications_Accessibility"] = {
	{"Xmag","xmag"},
}
Debian_menu["Debian_Applications_Data_Management"] = {
	{"Innotop", "x-terminal-emulator -e ".."/usr/bin/innotop"},
	{"LibreOffice 24.2 Base","libreoffice24.2 -base","/usr/share/icons/hicolor/32x32/apps/libreoffice24.2-base.png"},
}
Debian_menu["Debian_Applications_Editors"] = {
	{"LibreOffice 24.2 Writer","libreoffice24.2 -writer","/usr/share/icons/hicolor/32x32/apps/libreoffice24.2-writer.png"},
	{"Xedit","xedit"},
}
Debian_menu["Debian_Applications_Graphics"] = {
	{"dotty","/usr/bin/dotty"},
	{"lefty","/usr/bin/lefty"},
	{"LibreOffice 24.2 Draw","libreoffice24.2 -draw","/usr/share/icons/hicolor/32x32/apps/libreoffice24.2-draw.png"},
	{"LibreOffice 24.2 Impress","libreoffice24.2 -impress","/usr/share/icons/hicolor/32x32/apps/libreoffice24.2-impress.png"},
	{"X Window Snapshot","xwd | xwud"},
}
Debian_menu["Debian_Applications_Network_Communication"] = {
	{"PuTTY","/usr/bin/putty","/usr/share/pixmaps/putty.xpm"},
	{"Telnet", "x-terminal-emulator -e ".."/usr/bin/telnet.netkit"},
	{"Xbiff","xbiff"},
}
Debian_menu["Debian_Applications_Network_File_Transfer"] = {
	{"Transmission BitTorrent Client (GTK)","/usr/bin/transmission-gtk","/usr/share/pixmaps/transmission.xpm"},
}
Debian_menu["Debian_Applications_Network_Web_Browsing"] = {
	{"Google Chrome","/opt/google/chrome/google-chrome","/opt/google/chrome/product_logo_32.xpm"},
	{"Lynx", "x-terminal-emulator -e ".."lynx"},
}
Debian_menu["Debian_Applications_Network"] = {
	{ "Communication", Debian_menu["Debian_Applications_Network_Communication"] },
	{ "File Transfer", Debian_menu["Debian_Applications_Network_File_Transfer"] },
	{ "Web Browsing", Debian_menu["Debian_Applications_Network_Web_Browsing"] },
}
Debian_menu["Debian_Applications_Programming"] = {
	{"Erlang Shell", "x-terminal-emulator -e ".."/usr/bin/erl","/usr/share/pixmaps/erlang.xpm"},
	{"GNU Smalltalk", "x-terminal-emulator -e ".."/usr/bin/gst"},
	{"Guile 3.0", "x-terminal-emulator -e ".."/usr/bin/guile-3.0"},
	{"Monodoc (http)", "x-terminal-emulator -e ".."/usr/bin/monodoc-http","/usr/share/pixmaps/monodoc.xpm"},
	{"Tclsh8.6", "x-terminal-emulator -e ".."/usr/bin/tclsh8.6"},
	{"TkWish8.6","x-terminal-emulator -e /usr/bin/wish8.6"},
}
Debian_menu["Debian_Applications_Science_Electronics"] = {
	{"KiCad","/usr/bin/kicad",},
}
Debian_menu["Debian_Applications_Science_Mathematics"] = {
	{"Bc", "x-terminal-emulator -e ".."/usr/bin/bc"},
	{"Dc", "x-terminal-emulator -e ".."/usr/bin/dc"},
	{"LibreOffice 24.2 Calc","libreoffice24.2 -calc","/usr/share/icons/hicolor/32x32/apps/libreoffice24.2-calc.png"},
	{"Xcalc","xcalc"},
}
Debian_menu["Debian_Applications_Science"] = {
	{ "Electronics", Debian_menu["Debian_Applications_Science_Electronics"] },
	{ "Mathematics", Debian_menu["Debian_Applications_Science_Mathematics"] },
}
Debian_menu["Debian_Applications_Shells"] = {
	{"Bash", "x-terminal-emulator -e ".."/bin/bash --login"},
	{"Dash", "x-terminal-emulator -e ".."/bin/dash -i"},
	{"Sh", "x-terminal-emulator -e ".."/bin/sh --login"},
}
Debian_menu["Debian_Applications_System_Administration"] = {
	{"Debian Task selector", "x-terminal-emulator -e ".."su-to-root -c tasksel"},
	{"Editres","editres"},
	{"Xclipboard","xclipboard"},
	{"Xfontsel","xfontsel"},
	{"Xkill","xkill"},
	{"Xrefresh","xrefresh"},
}
Debian_menu["Debian_Applications_System_Hardware"] = {
	{"Xvidtune","xvidtune"},
}
Debian_menu["Debian_Applications_System_Monitoring"] = {
	{"Pstree", "x-terminal-emulator -e ".."/usr/bin/pstree.x11","/usr/share/pixmaps/pstree16.xpm"},
	{"Top", "x-terminal-emulator -e ".."/usr/bin/top"},
	{"Xconsole","xconsole -file /dev/xconsole"},
	{"Xev","x-terminal-emulator -e xev"},
	{"Xload","xload"},
}
Debian_menu["Debian_Applications_System_Package_Management"] = {
	{"Aptitude Package Manager (text)", "x-terminal-emulator -e ".."/usr/bin/aptitude-curses"},
	{"Synaptic Package Manager","x-terminal-emulator -e synaptic-pkexec","/usr/share/synaptic/pixmaps/synaptic_32x32.xpm"},
}
Debian_menu["Debian_Applications_System"] = {
	{ "Administration", Debian_menu["Debian_Applications_System_Administration"] },
	{ "Hardware", Debian_menu["Debian_Applications_System_Hardware"] },
	{ "Monitoring", Debian_menu["Debian_Applications_System_Monitoring"] },
	{ "Package Management", Debian_menu["Debian_Applications_System_Package_Management"] },
}
Debian_menu["Debian_Applications_Viewers"] = {
	{"docker","/usr/bin/wmdocker"},
	{"Xditview","xditview"},
}
Debian_menu["Debian_Applications"] = {
	{ "Accessibility", Debian_menu["Debian_Applications_Accessibility"] },
	{ "Data Management", Debian_menu["Debian_Applications_Data_Management"] },
	{ "Editors", Debian_menu["Debian_Applications_Editors"] },
	{ "Graphics", Debian_menu["Debian_Applications_Graphics"] },
	{ "Network", Debian_menu["Debian_Applications_Network"] },
	{ "Programming", Debian_menu["Debian_Applications_Programming"] },
	{ "Science", Debian_menu["Debian_Applications_Science"] },
	{ "Shells", Debian_menu["Debian_Applications_Shells"] },
	{ "System", Debian_menu["Debian_Applications_System"] },
	{ "Viewers", Debian_menu["Debian_Applications_Viewers"] },
}
Debian_menu["Debian_Games_Blocks"] = {
	{"Crack Attack!","/usr/games/crack-attack","/usr/share/pixmaps/crack-attack.xpm"},
	{"cuyo","/usr/games/cuyo","/usr/share/pixmaps/cuyo.xpm"},
	{"FloboPuyo","/usr/games/flobopuyo","/usr/share/pixmaps/flobopuyo.xpm"},
	{"FreeAlchemist","/usr/games/freealchemist","/usr/share/pixmaps/freealchemist.xpm"},
	{"LTris","/usr/games/ltris","/usr/share/pixmaps/ltris.xpm"},
	{"Netris", "x-terminal-emulator -e ".."/usr/games/netris"},
	{"XBubble","/usr/games/xbubble"},
}
Debian_menu["Debian_Games_Toys"] = {
	{"Oclock","oclock"},
	{"Xclock (analog)","xclock -analog"},
	{"Xclock (digital)","xclock -digital -update 1"},
	{"Xeyes","xeyes"},
	{"Xlogo","xlogo"},
}
Debian_menu["Debian_Games"] = {
	{ "Blocks", Debian_menu["Debian_Games_Blocks"] },
	{ "Toys", Debian_menu["Debian_Games_Toys"] },
}
Debian_menu["Debian_Help"] = {
	{"Xman","xman"},
}
Debian_menu["Debian_Screen_Locking"] = {
	{"Lock Screen (XScreenSaver)","/usr/bin/xscreensaver-command -lock"},
}
Debian_menu["Debian_Screen_Saving"] = {
	{"Activate ScreenSaver (Next)","/usr/bin/xscreensaver-command -next"},
	{"Activate ScreenSaver (Previous)","/usr/bin/xscreensaver-command -prev"},
	{"Activate ScreenSaver (Random)","/usr/bin/xscreensaver-command -activate"},
	{"Demo Screen Hacks","/usr/bin/xscreensaver-command -demo"},
	{"Disable XScreenSaver","/usr/bin/xscreensaver-command -exit"},
	{"Enable XScreenSaver","/usr/bin/xscreensaver"},
	{"Reinitialize XScreenSaver","/usr/bin/xscreensaver-command -restart"},
	{"ScreenSaver Preferences","/usr/bin/xscreensaver-command -prefs"},
}
Debian_menu["Debian_Screen"] = {
	{ "Locking", Debian_menu["Debian_Screen_Locking"] },
	{ "Saving", Debian_menu["Debian_Screen_Saving"] },
}
Debian_menu["Debian_Window_Managers"] = {
	{"awesome",function () awesome.exec("/usr/bin/awesome") end,"/usr/share/pixmaps/awesome.xpm"},
	{"Dwm",function () awesome.exec("/usr/bin/dwm") end},
	{"IceWM",function () awesome.exec("/usr/bin/icewm") end,"/usr/share/icewm/icons/icewm_16x16.xpm"},
}
Debian_menu["Debian"] = {
	{ "Applications", Debian_menu["Debian_Applications"] },
	{ "Games", Debian_menu["Debian_Games"] },
	{ "Help", Debian_menu["Debian_Help"] },
	{ "Screen", Debian_menu["Debian_Screen"] },
	{ "Window Managers", Debian_menu["Debian_Window_Managers"] },
}

debian = { menu = { Debian_menu = Debian_menu } }
return debian