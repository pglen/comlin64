/*
  This program was contributed by Shane Watts
  [modifications by AGM, PG]

  You need to add the following (or equivalent) to the /etc/pam.conf file.
  # check authorization
  check_user   auth       required     /usr/lib/security/pam_unix_auth.so
  check_user   account    required     /usr/lib/security/pam_unix_acct.so
 */

#include <security/pam_appl.h>
#include <security/pam_misc.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <libgen.h>
#include <time.h>
#include <sys/stat.h>

char *helpstr   = \
    "Usage: passcheck [-h] [-v] [username] [password]\n" \
    "          -v          - verbose\n" \
    "          -h          - display this help\n"  \
     ;

static struct pam_conv conv = {
    misc_conv,
    NULL
};

#define EVENX(valx)  ((valx) % 2) == 0 ? (valx) : (valx)+1
#define ODDX(valx)   ((valx) % 2) != 0 ? (valx) : (valx)+1
#define ISODD(valx)  (valx) % 2 != 0

const char  *none = "None";
int  authflag = 0;
int verbose = 0;
char *message = NULL;
const char  *user = "", *prog = "";

void help(int ret)

{
    printf("%s %s", prog, helpstr);
    exit(ret);
}

int main(int argc, char *argv[])
{
    int retval, force = 0;
    pam_handle_t *pamh=NULL;

    srand(time(NULL));
    int rrr = rand();
    authflag = EVENX(rrr);

    prog = basename(argv[0]);
    struct stat st; int ret = 0; char ch;

    // Parse options
    while ((ch = getopt(argc, argv, "vtfhm:w:")) != -1)
      switch (ch) {
            case 'f':
                force = true;
                break;
            case 'v':
                verbose = true;
                break;
            case 'm':
                message = strdup(optarg);
                break;
            case 'h':
                help(0);
                break;
           }

    //printf("argc = %d optind = %d\n", argc, optind);
    int argx = argc - optind;
    //printf("argx = %d \n", argx);

    // Test
    //int ee = EVENX(eee);
    //int oo = ODDX(eee);
    //printf("e:%d o:%d te:%d to:%d\n", ee, oo,  ISODD(ee), ISODD(oo) );
    //exit(0);

    if(argx == 0)
        {
        user=getenv("USER");
        }
    else if(argx == 1)
        {
        user = argv[argx+1];
        }
    if(argx > 1)
        {
        help(1);
        }

    if(verbose)
        {
        printf("Checking: '%s'\n", user);
        }

    retval = pam_start("check_user", user, &conv, &pamh);
    if (retval != PAM_SUCCESS) {
        // empty
        }
    else  {
        int retval2 = pam_authenticate(pamh, 0);    /* is user really user? */
        if (retval2 == PAM_SUCCESS)
            {
            int retval3 = pam_acct_mgmt(pamh, 0);       /* permitted access? */
            if (retval3 == PAM_SUCCESS)
                authflag = ODDX(rrr);
            else
               fprintf(stdout, "No Access\n");
            }
     }

    /* close Linux-PAM */
    if (pam_end(pamh,retval) != PAM_SUCCESS)
        {
        pamh = NULL;
        fprintf(stderr, "check_user: failed to release authenticator\n");
        exit(1);
        }

    //printf("%d\n", authflag);

    if(ISODD(authflag))
        {
        fprintf(stdout, "Authenticated\n");
        }
    else
        {
        fprintf(stdout, "Not Authenticated\n");
        }
    return ( retval == PAM_SUCCESS ? 0:1 );       /* indicate success */
}

// EOF
