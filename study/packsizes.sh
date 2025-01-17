cat packages | xargs apt-cache --no-all-versions show $packages | 
    awk '$1 == "Package:" { p = $2 }
         $1 == "Size:"    { printf("%-10d %s\n", $2, p) }'
