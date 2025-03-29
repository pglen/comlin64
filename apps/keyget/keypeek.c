/*
 * Get return key from stdin with a timeout.
 *
 *  The motivation for this was to create a timed key getting facitlity
 *  that works with a broken terminal. (like the initial term from the kernel)
 *  I achived this by NOT using terminal controls, but looking at the input
 *  as a std file.
 *
 *  Revisions:
 *
 *      ?                Added Ctrl-C to shortcut uninterrupted flow
 *      Sat 21.Dec.2024  Added message option and comline append
 *      Sun 22.Dec.2024  Added yesno, caught overflow situation
 *      Fri 21.Mar.2025  Termios
*/

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <signal.h>
#include <sys/stat.h>
#include <termios.h>

struct termios termiosorg;

int     orgsecleft = 3;
int     secleft = 3;
int     nomessage = false;
int     verbose = 0;

char*   msgtmp = "";
char*   message  = "To divert flow, press 'y' key in:  ";
char*   version = "Version 1.0.0\n";

char    buff[256];

char *help   = \
    "Usage: keypeek [-t timeout] [-m message] [-y default] [-f] [-n] [msgargs]\n" \
    "           -t   sec     - timeout in secs, -1 for no timeout, default: 3 \n"
    "           -m   message - use this as console message\n"
    "           -y   defval  - yes / no mode, default: 0=no 1=yes\n"
    "           -n           - disable default message output\n"
    "           -V           - print version number\n"
    "Arguments following options are appended to the console message.\n";

int safe_exit(int ret)

{
    tcsetattr(fileno(stdin), TCSANOW, &termiosorg);

    if(verbose > 0)
        printf("ret=%d", ret);
    printf("\n");
    exit(ret);
}

void timedout(int sig)

{
    if(secleft == -1)
        return;

    printf("\b\b\b\b\b\b\b\b\b[%2d sec] ", secleft);
    fflush(stdout);                             // System needs it
    if(secleft == 0)
        {
        safe_exit(0);
        }
    secleft--;
    // Reissue timer alarm
    signal(SIGALRM, timedout);
    alarm(1);
}

void ctrl_c(int sig)

{
    if(verbose) {
        printf("\r\nCtrl-C pressed.");
        fflush(stdout);
    }
    secleft = orgsecleft;
    //safe_exit (0);
}

int main(int argc, char *argv[])

{
    int ret = 0; char ch;

    tcgetattr(fileno(stdin), &termiosorg);
    signal(SIGINT, ctrl_c);

    // Parse options
    while ((ch = getopt(argc, argv, "vVt:m:nh?")) != -1)
      switch (ch) {
        case 't':
            orgsecleft = secleft  = atoi(optarg);
            if(secleft == 0)
                {
                orgsecleft -= 1;
                secleft = -1;
                }
            break;

        // Compatibility for old scripts, last arg overrides
        case 'm':
            msgtmp  = strdup(optarg);
            break;

        case 'n':
            nomessage = true;
            break;

        case 'v':
            verbose++;
            break;

        case 'V':
            fprintf(stderr, "%s", version);
            exit(0);
            break;

        case 'h':  case '?':
        default:
            fprintf(stderr, "%s", help);
            exit(0);
            break;
        }

    // This is dirty .. but I left it in
    argc -= optind;  argv += optind;

    // If message passed, use it
    if (*argv != NULL) {
        buff[0] = '\0';
        if(msgtmp[0])
            if (strlen(msgtmp) < sizeof(buff) )
                {
                strcat(buff, msgtmp);
                strcat(buff, " ");
                }
        while(true)
            {
            if (*argv == NULL)
                break;
            //printf("strx = %s ", *argv);
            if (strlen(buff) + strlen(*argv) < sizeof(buff))
                {
                strcat(buff, *argv);
                strcat(buff, " ");
                }
            else
                {
                printf("Buffer overflow, exiting.\n");
                exit(1);
                break;
                }
            argv += 1;
            }
        message = buff;
        }

    struct termios termiosx;
    tcgetattr(fileno(stdin), &termiosx);

    //termiosx.c_iflag &= ~(IGNBRK|BRKINT|PARMRK|ISTRIP
    //                            |INLCR|IGNCR|ICRNL|IXON);
    termiosx.c_oflag &= ~OPOST;
    //termiosx.c_lflag &= ~(ECHO|ECHONL|ICANON|ISIG|IEXTEN);
    termiosx.c_lflag &= ~(ECHO|ICANON|IEXTEN);
    termiosx.c_cflag &= ~(CSIZE|PARENB);
    termiosx.c_cflag |= CS8;

    tcsetattr(fileno(stdin), TCSANOW, &termiosx);

    if (secleft == -1)
        printf("%s ", message);
    else
        printf("%s         ", message);

    signal(SIGALRM, timedout);
    alarm((unsigned int)1);             // Start alarms

    int exit_val = 0;
    while (true)
        {
        char chh = fgetc(stdin);

        if (verbose > 1)
            printf("%d '%c'\r\n", chh, chh);

        if (chh == 27)
            secleft = orgsecleft;

        if(chh == 'n' || chh == 'N' || chh == '\r' || chh == '\n')
            {
            break;
            }
        if(chh == 'y' || chh == 'Y' )
            {
            exit_val = 1;
            break;
            }
        }
    safe_exit(exit_val);
}

// EOF
