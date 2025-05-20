apt list --installed  | awk -F "/" '{print($1)}' | grep -v "Listing..." | \
 xargs -i apt-cache show {} | \
  awk ' $1=="Package:"        { p=$2; u=1}  
        $1=="Priority:" { if ($2=="optional") { printf("%s\n", p); u=0; } }  
'

