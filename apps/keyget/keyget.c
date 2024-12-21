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
 *             Added Ctrl-C to shortcut uninterrupted flow
*/

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <signal.h>
#include <sys/stat.h>

int retalarm = 0, secleft = 5;

char chstr[12] = "";

char* message  = "To intercept current flow, press Enter in: ";
char* message2 = "Enter to continue: ";
char* message3 = "";
int   nomessage = false;
char  buff[1000];

char help[]   = \
    "Usage: keyget [-t timeout] [-m message] [-n] [msgargs]\n" \
    "              -t   timeout in seconds, value of 0 for no timeout\n"
    "              -n   no message output\n"
    "              -m   use this message\n"
    " Arguments following options are used as message\n";

// -----------------------------------------------------------------------
// Execute timeout routine

void timedout(int sig)

{
    retalarm = 1;

    if(secleft != -1)
        {
        printf("\b\b\b\b\b\b\b\b\b[%2d sec] ", secleft);
        fflush(stdout);                             // System needs it

        if(secleft == 0)
            {
            // Done
            printf("%s", "\n");  exit(1);
            }
        secleft--;
        }
    // Re - issue timer alarm
    signal(SIGALRM, timedout);
    alarm(1);
}

void ctrl_c(int sig)

{
    printf("Ctrl-C pressed\n");
    exit (0);
}

// -----------------------------------------------------------------------

int main(int argc, char *argv[])

{
    int ret = 0; char ch;

    // Parse options
    while ((ch = getopt(argc, argv, "t:m:nh?")) != -1)
      switch (ch) {
        case 't':
            secleft  = atoi(optarg);
            if(secleft == 0)
                secleft = -1;
            break;

        // Compatibility for old scripts, last arg overrides
        case 'm':
            message3  = strdup(optarg);
            break;

        case 'n':
            nomessage = true;
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
        while(true)
            {
            if (*argv == NULL)
                break;
            //printf("strx = %s ", *argv);
            strcat(buff, *argv);
            strcat(buff, " ");
            argv += 1;
            }
        message = buff;
        }
    else if(message3[0])
        {
        message = message3;
        }
    else
        {
        if (secleft == -1)
            message = message2;
        }

    if (! nomessage)
        {
        printf("%s", message);              // Show message
        if (secleft != -1)
            printf("          ");           // Placeholder for seconds message
        }
    //signal(SIGINT, SIG_IGN);           // Disable ctrl-c
    //signal(SIGINT, ctrl_c);              //
    //signal(SIGQUIT, ctrl_c);             //

    signal(SIGALRM, timedout);
    alarm((unsigned int)1);             // Start alarms

    fgets(&chstr[0], sizeof(chstr), stdin);          // Get String

    exit (0);
}


