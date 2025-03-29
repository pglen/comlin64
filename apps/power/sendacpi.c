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

char buf[512]; char buf2[600];

int sendacpi(const char *sname)

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

        strcpy(buf, "button/power 0000");
        printf("Sending %s to %s\n", buf, sname);
        //int slen=sendto(m_acpidsock, buf, strlen(buf), 0,
        //            (struct sockaddr *)&m_acpidsockaddr, sizeof(m_acpidsockaddr));
        int slen=send(m_acpidsock, buf, strlen(buf), 0);

        printf("Sent %d %s\n", slen, strerror(errno));
        }

    return 0;
}

char *help   = \
    "Usage: senrcpi [-V] [-v] [-h] \n" \
    "           -V           - print version number\n"
    "           -v           - add verbosity level (-vv.. for more)\n"
    "           -h           - help (this screen)\n"
    ;

void ctrl_c(int sig)

{
    if(verbose)
        {
        //printf("\r\nCtrl-C pressed.");
        //fflush(stdout);
        }
}

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
        snprintf(buf2, sizeof(buf2), "%s %s", execname, teststr);

        if(verbose)
            printf("Executing '%s' args: '%s'\n", execname, buf2);

        if(loglevel)
            syslog(LOG_INFO, "%s:%d %s %s", __FILE__, __LINE__, "Execute:", buf2 );
        system(buf2);
        exit(0);
        }

    sendacpi(sockname);

    if(m_acpidsock>=0)
        {
        close(m_acpidsock);
        m_acpidsock=-1;
        }
    exit(0);
}

//# EOF