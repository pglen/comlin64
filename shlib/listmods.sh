cat /proc/modules | cut -f 1 -d " " | while read module; do \
 RES=$(echo $module | grep $1)
 #echo "RES $RES"
 if [ "$RES" != "" ]; then
  echo "Module: $module"; \
  if [ -d "/sys/module/$module/parameters" ]; then \
   ls /sys/module/$module/parameters/ | while read parameter; do \
    echo -n "Parameter: $parameter --> "; \
    cat /sys/module/$module/parameters/$parameter; \
   done; \
  fi; \
 echo; \
 fi
done
