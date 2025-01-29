apt show $1 2>/dev/null |  awk ' #BEGIN {print("start\n");}
        $1=="Package:"        { p=$2;}
        $1=="Installed-Size:" { printf("%10d %s\n", $2, p) } '
