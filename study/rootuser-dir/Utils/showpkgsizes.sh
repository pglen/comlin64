apt list --installed 2>/dev/null | awk -F "/" '{print($1)}' | grep -v "Listing..." | \
 xargs -i ./showone.sh {}

#$(apt show {} | \
#  awk ' BEGIN {print("start\n");}
#	$1=="Package:"        { p=$2; u=1}  
#        $1=="Installed-Size:" { if (u) { printf("%10d %s\n", $2, p); u=0; } }  
#')

