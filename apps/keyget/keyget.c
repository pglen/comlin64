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

int     retalarm = 0, secleft = 5;
int     nomessage = false, yesno = false;
int     yesdef = 0;
int     forceyn = false;

char    chstr[12] = "";
char    buff[512];
char    buff2[128];

char*   msgtmp = "";

char*   message  = "To intercept current flow, press Enter in: ";
char*   message2 = "Press Enter to continue: ";
char*   message3 = "Press Y or N (default is %s): ";
char*   message4 = "Press Y or N: ";
char*   version = "Version 1.0.0\n";
char *help   = \
    "Usage: keyget [-t timeout] [-m message] [-y default] [-f] [-n] [msgargs]\n" \
    "           -t   sec     - Timeout in secs, 0 for no timeout, default: 5 \n"
    "           -m   message - Use this as console message.\n"
    "           -y   defval  - Start in yes / no mode, default: 0=no 1=yes\n"
    "           -f           - Force yes or no (captivate)\n"
    "           -n           - Disable default message output.\n"
    "           -V           - Print version number.\n"
    "Arguments following options are appended to the console message.\n";

// -----------------------------------------------------------------------
// Execute timeout routine

char *yesno_str(int val)

{
    if(val)
        return("Yes");
    else
        return("No");
}

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
    printf("\nCtrl-C pressed, press Y/N. Try again: ");
    fflush(stdout);

    //exit (0);
}

// -----------------------------------------------------------------------

int main(int argc, char *argv[])

{
    int ret = 0; char ch;

    //printf("test2\n");

    // Parse options
    while ((ch = getopt(argc, argv, "Vt:m:nh?y:f")) != -1)
      switch (ch) {
        case 't':
            secleft  = atoi(optarg);
            if(secleft == 0)
                secleft = -1;
            break;

        // Compatibility for old scripts, last arg overrides
        case 'm':
            msgtmp  = strdup(optarg);
            break;

        case 'n':
            nomessage = true;
            break;

        case 'f':
            forceyn = true;
            break;

        case 'V':
            fprintf(stderr, "%s", version);
            exit(0);
            break;

        case 'y':
            yesno = true;
            yesdef = atoi(optarg);
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
    else if(msgtmp[0])
        {
        message = msgtmp;
        }
    else
        {
        // Fill in defaults
        if(yesno)
            {
            if(forceyn)
                sprintf(buff2, "%s", message4);
            else
                sprintf(buff2, message3, yesno_str(yesdef));
            message = buff2;
            }
        else if (secleft == -1)
            message = message2;
        }
    if (!nomessage)
        {
        printf("%s", message);              // Show message

        if (secleft != -1 ) //&& yesno == 0)
            printf("          ");           // Placeholder for seconds message
        fflush(stdout);
        }

    //signal(SIGINT, SIG_IGN);              // Disable ctrl-c

    if(forceyn && yesno)
        signal(SIGINT, ctrl_c);

    if (secleft != -1 && yesno == 0)
        {
        signal(SIGALRM, timedout);
        alarm((unsigned int)1);             // Start alarms
        }

    if(yesno)
        {
        while(1)
            {
            fgets(&chstr[0], sizeof(chstr), stdin);          // Get String
            //printf("got: '%s'", chstr);

            if(strstr(chstr, "y") || strstr(chstr, "Y"))
                exit(1);
            else if(strstr(chstr, "n") || strstr(chstr, "N"))
                exit(0);
            else
                if(forceyn)
                    {
                    printf("No Y/N selection, try again: ");
                    fflush(stdout);   // System needs it
                    }
                else
                    exit(yesdef);
            }
        exit(0);
        }
    else
        {
        fgets(&chstr[0], sizeof(chstr), stdin);          // Get String
        exit (0);
        }
}

//# EOF
