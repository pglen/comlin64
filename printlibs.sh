ldd $1 | grep x86_64 | awk '{ print $3; '}
