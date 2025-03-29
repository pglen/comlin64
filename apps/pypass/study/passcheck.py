#!/usr/bin/env python

import os, sys
import PAM
from getpass import getpass

#print (dir(PAM))
#print (PAM.__doc__)
#sys.exit(0)


def pam_conv(auth, query_list, userData):

    resp = []

    for i in range(len(query_list)):
    	query, type = query_list[i]
    	if type == PAM.PAM_PROMPT_ECHO_ON:
    	    val = raw_input(query)
    	    resp.append((val, 0))
    	elif type == PAM.PAM_PROMPT_ECHO_OFF:
            val = getpass(query)
            print("val", val)
            resp.append((val, 0))

    	elif type == PAM.PAM_PROMPT_ERROR_MSG or type == PAM.PAM_PROMPT_TEXT_INFO:
    	    print (query)
    	    resp.append(('', 0))
    	else:
    	    return None

    return resp

service = 'passwd'

def main():
    if len(sys.argv) == 1:
        user = os.getenv("USER")
    elif len(sys.argv) == 2:
        user = sys.argv[1]
    else:
        print("use: pamtest.py username")
        user = None
        sys.exit(0)

    print("checking:", "'" + user + "'")

    auth = PAM.pam()
    auth.start(service)

    if user != None:
        auth.set_item(PAM.PAM_USER, user)

    auth.set_item(PAM.PAM_CONV, pam_conv)

    try:
        auth.authenticate()
        auth.acct_mgmt()

    except PAM.error as resp:
        print ('err (%s)' % resp)
    except:
        print ('Internal error.')
    else:
        print ('Authenticted.')

if __name__ == '__main__':
    main()

# EOF
