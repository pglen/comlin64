/*
 * We created two excutables, following Linux tradition. In the origianl
 * implementation, these are symlinks to one excutable, but we are
 * keeping it simple.
 * The define COMPILE_POWEROFF determines which functionality is added.
 */

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <errno.h>
#include <signal.h>
#include <sys/stat.h>

#include "linux_reboot.h"

char *help   = \
    "Usage: linux_[poweroff | reboot] [-h] [-t] [-f] [w seconds] [-m message]\n" \
    "          -f          - force\n" \
    "          -m msg      - send message\n" \
    "          -w sec      - wait seconds before action\n" \
    "          -t          - test (simulate) .. still send message\n" \
    "          -h          - display this help\n"  \
     ;

int force = false, testx = false, verbose = false, waitx = 0;
char *message = NULL;

#ifdef COMPILE_POWEROFF
    char *opstr = "shutdown";
#else
    char *opstr = "reboot";
#endif

static int my_reboot(int cmd) {
     if(verbose)
        {
        printf("%s ... \n", opstr);
        }
	//return reboot(LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2, cmd);
	return reboot(cmd);
}

// -----------------------------------------------------------------------

int main(int argc, char *argv[])

{
    struct stat st; int ret = 0; char ch;

    // Parse options
    while ((ch = getopt(argc, argv, "vtfhm:w:")) != -1)
      switch (ch) {
            case 'f':
                force = true;
                break;
            case 't':
                testx = true;
                break;
            case 'v':
                verbose = true;
                break;
            case 'm':
                message = strdup(optarg);
                break;
            case 'w':
                waitx = atoi(optarg);
                break;
            case 'h':
                printf("%s", help);
                exit(0);
                break;
           }

    if(verbose)
        {
        printf("Waiting: %d seconds\n", waitx);
        printf("Sending message: '%s'\n", message);
        }
    if(waitx)
        {
        if(verbose)
            printf("Sleeping: %d seconds\n", waitx);

        sleep(waitx);
        }
    // Run only if the reboot / shutdown file exist of in forced mode.
    // This prevents accidental reboots by the user
    if ( (stat(reboot_file, &st) < 0) && !force)
        {
        printf( \
        "Reboot condition is not met. (file %s must exist or use -f option)\n",
                    reboot_file);
        exit(1);
        }
    if(!testx)
        {
        sync();

        int ret = 0;
        #ifdef COMPILE_POWEROFF
            ret = my_reboot(LINUX_REBOOT_CMD_POWER_OFF);
        #else
            ret = my_reboot(LINUX_REBOOT_CMD_RESTART);
        #endif
        if (ret < 0)
            {
            printf("Cannot %s: %s\n", opstr, strerror(errno));
            }
        }
    else
        {
        if(verbose)
            #ifdef COMPILE_POWEROFF
                printf("Would execute: poweroff\n");
            #else
                printf("Would execute: reboot\n");
            #endif
        }
    exit(ret);
}

// EOF
