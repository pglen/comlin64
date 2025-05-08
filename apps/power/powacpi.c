// Listen to ACPI events

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <syslog.h>
#include <errno.h>
#include <signal.h>
#include <time.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/time.h>

#define _STRINGIZE(x) #x
#define STRINGIZE(x) _STRINGIZE(x)

int m_acpidsock;
struct sockaddr_un m_acpidsockaddr;

int     verbose = 0;
int     loglevel = 0;

char    *sockname = "/var/run/acpid.socket";
char    *version = "Version 1.0.0, built on Sun 23.Mar.2025\n";
char    *teststr = NULL;
char    *execname = "/usr/bin/powbutt.sh";
char    *fstr = "%s %s";

char buf[512]; char buf2[600];

//# 0 ------------ 1 ------------- 2 ---------------
//#    |       |
//#    |               |

#define USEC 1000000

/*
 * Get time diff in microseconds between two timeval points
*/

int gettimediff(struct timeval *tv, struct timeval *tv2)
{
    //printf("ss=%ld us=%ld\n", tv->tv_sec, tv->tv_usec);
    //printf("ss=%ld us=%ld\n", tv2->tv_sec, tv2->tv_usec);

    long secx =  tv2->tv_sec  - tv->tv_sec;
    long diff =  secx * USEC;
    if (secx)    // has crossed sec boundary
        diff += tv2->tv_usec + (USEC - tv->tv_usec) - USEC;
    else
        diff += tv2->tv_usec - tv->tv_usec;
    return diff;
}

int startacpi(const char *sname)

{
    if(verbose > 0)
        printf("Started acpi listen on '%s'\n", sockname);

    /* Connect to acpid socket */
    m_acpidsock = socket(AF_UNIX, SOCK_STREAM, 0);
    if(m_acpidsock>=0)
        {
        m_acpidsockaddr.sun_family = AF_UNIX;
        strcpy(m_acpidsockaddr.sun_path, sname);
        if(connect(m_acpidsock, (struct sockaddr *)&m_acpidsockaddr, 108)<0)
            {
            /* can't connect */
            printf("Cannot connect to '%s' - %s \n",
                                m_acpidsockaddr.sun_path, strerror(errno));
            close(m_acpidsock);
            m_acpidsock = -1;
            exit(1);
            }
        }

    struct timeval tv; struct timezone tz;
    gettimeofday(&tv, &tz);

    while(1)
        {
        int ttt = time(NULL);
        int slen=recv(m_acpidsock, buf, sizeof(buf), 0);

        if(slen>0)
            {
            buf[slen]=0;

            struct timeval tv2; struct timezone tz2;
            gettimeofday(&tv2, &tz2);
            long retd = gettimediff(&tv, &tv2);
            if(retd < 100000)
                {
                usleep(100000);
                }

            snprintf(buf2, sizeof(buf2), fstr, execname, buf);
            if(verbose)
                printf("Command: '%s'", buf2);
            if(loglevel)
                syslog(LOG_INFO, "%s:%d %s %s", __FILE__, __LINE__, "Execute:", buf2 );
            int ret = system(buf2);
            if(ret < 0)
                {
                printf("Cannot execute: %s - %s", buf2, strerror(errno));
                syslog(LOG_INFO, "%s:%d %s %s", __FILE__, __LINE__, "Cannot execute:", buf2 );
                }
            }
        }
    return 0;
}

// Test measure time
//struct timezone tz; struct timeval tv;
//gettimeofday(&tv, &tz);
//sleep(1);
//struct timezone tz2; struct timeval tv2;
//gettimeofday(&tv2, &tz2);
//long diff = gettimediff(&tv, &tv2);
//printf("diff=%ld\n", diff);
//exit(0);

void ctrl_c(int sig)

{
    // Assume terminal is foreground (for debug)
    if(verbose)
        {
        printf("\r\nCtrl-C pressed.\r\n");
        fflush(stdout);
        exit(0);
        }
}

char *help   = \
    "Usage: powacpi [-V] [-v] [-h] \n" \
    "           -t str       - execute test event string.\n"
    "           -x str       - batch name.\n"
    "           -s           - socket name.\n"
    "           -l           - add log level. (-ll.. for more)\n"
    "           -v           - add verbosity level. (-vv.. for more)\n"
    "           -V           - print version number, build date.\n"
    "           -h           - show help. (this screen)\n"
    ;

int main(int argc, char *argv[])

{
    char ch;
    signal(SIGINT, ctrl_c);

    //syslog(LOG_INFO, "%s", "Program started.");
    //syslog(LOG_INFO, "%s:%d %s", __FILE__, __LINE__, "Started" );

    while ((ch = getopt(argc, argv, "t:lvVs:x:h?")) != -1)
      switch (ch) {

        case 'x':
            execname  = strdup(optarg);
            break;

        case 't':
            teststr  = strdup(optarg);
            break;

        case 's':
            sockname  = strdup(optarg);
            break;

        case 'v':
            verbose++;
            break;

        case 'l':
            loglevel++;
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

    if (teststr)
        {
        snprintf(buf2, sizeof(buf2), fstr, execname, teststr);

        if(verbose)
            printf("Executing '%s' args: '%s'\n", execname, buf2);

        if(loglevel)
            syslog(LOG_INFO, "%s:%d %s %s", __FILE__, __LINE__, "Execute:", buf2 );
        system(buf2);
        exit(0);
        }

    startacpi(sockname);

    if(m_acpidsock>=0)
        {
        close(m_acpidsock);
        m_acpidsock=-1;
        }
    exit(0);
}

//# EOF