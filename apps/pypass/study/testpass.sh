
rm /tmp/myfifo
mkfifo /tmp/myfifo

#(echo -ne 'good\0' > /tmp/myfifo & /usr/sbin/unix_chkpwd david nullok < /tmp/myfifo ) ; echo $?
#(echo -ne 'bad\0' > /tmp/myfifo & /usr/sbin/unix_chkpwd david nullok < /tmp/myfifo ) ; echo $?
(echo -ne 'kitty1357\0' > /tmp/myfifo &
    /usr/sbin/unix_chkpwd peterlen nullok < /tmp/myfifo ) ; echo $?
