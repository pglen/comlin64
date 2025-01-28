#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

/*
    2008 - Copyright by Bee <http://www.honeybeenet.altervista.org>.
    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
*/

#define BEESU_VERSION "2.7"

struct s_argument
{
    char **items;
    unsigned int count;
    unsigned long int size;
};

void add_argument(struct s_argument *arguments, char *argument);
void arg_error(const int id, const char *me, const char *arg);
const char *first_valid_arg_name_of(const char *arg, const char *names);
const char *first_invalid_arg_name_not_of(const char *arg, const char *names);

#define BEESU_BOOLEAN_FALSE 0
#define BEESU_BOOLEAN_TRUE 1
typedef unsigned beesu_boolean_t;

const static char const_shell[]="/bin/bash";
const static char const_su[]="/bin/su";
const static char const_configuration[]="/etc/beesu.conf";
#define READ_BUFFER_SIZE (1024*8)

#define NO_EXTERNAL_ARGS (-100)

const static char const_valid_args[]="Pvclmfs";//XXX: to udpate with new arguments!!

int main(int argc, char *argv[])
{
    int i;
    beesu_boolean_t found;

    char *arg;
    int local_params = 1;
    int external_params = NO_EXTERNAL_ARGS;
    beesu_boolean_t local_verbose = BEESU_BOOLEAN_FALSE;
    beesu_boolean_t print_configuration_file_and_quit = BEESU_BOOLEAN_FALSE;

    beesu_boolean_t simulate_login = BEESU_BOOLEAN_FALSE;
    beesu_boolean_t compress_params = BEESU_BOOLEAN_TRUE;
    beesu_boolean_t preserve_environment = BEESU_BOOLEAN_FALSE;
    beesu_boolean_t fast = BEESU_BOOLEAN_FALSE;
    char *shell = NULL;

    struct s_argument arguments;
    struct s_argument arguments_su;

    char *arguments_su_memory = NULL;

    int exec_result;

    FILE *f_config;
    char *f_read_buffer;
    char f_block_name[10];
    beesu_boolean_t command_in_whitelist = BEESU_BOOLEAN_FALSE;



    arguments.items = NULL;
    arguments.count = 0;
    arguments.size = 0;
    arguments_su.items = NULL;
    arguments_su.count = 0;
    arguments_su.size = 0;

    for(i = 1; i < argc; i++)
    {
        arg = argv[i];
        if(local_params == 1)
        {
            found = BEESU_BOOLEAN_FALSE;
            if(strlen(arg) == 0)
            {
                continue;
            }
            if(first_valid_arg_name_of(arg, "c") && first_valid_arg_name_of(arg, "s"))
            {
                arg_error(2, argv[0], arg);
                return EXIT_FAILURE;
            }
            if(strcmp(arg,"--version") == 0)
            {
                printf("beesu " BEESU_VERSION "\n");
                return EXIT_SUCCESS;
            }
            if(strcmp(arg,"--print-conf") == 0)
            {
                found = BEESU_BOOLEAN_TRUE;
                print_configuration_file_and_quit = BEESU_BOOLEAN_TRUE;
            }
            if(first_valid_arg_name_of(arg, "P"))
            {
                found = BEESU_BOOLEAN_TRUE;
                compress_params = BEESU_BOOLEAN_FALSE;
            }
            if(first_valid_arg_name_of(arg, "v"))
            {
                found = BEESU_BOOLEAN_TRUE;
                local_verbose = BEESU_BOOLEAN_TRUE;
            }
            if(first_valid_arg_name_of(arg, "c"))
            {
                found = BEESU_BOOLEAN_TRUE;
                local_params = 100;
                if(argv[i+1] == NULL)
                {
                    arg_error(1, argv[0], arg);
                    return EXIT_FAILURE;
                }
            }
            if(first_valid_arg_name_of(arg, "l") || strcmp(arg,"-") == 0 || strcmp(arg,"--login") == 0)
            {
                found = BEESU_BOOLEAN_TRUE;
                simulate_login = BEESU_BOOLEAN_TRUE;
            }
            if(first_valid_arg_name_of(arg, "m") || strcmp(arg,"--preserve-environment") == 0)
            {
                found = BEESU_BOOLEAN_TRUE;
                preserve_environment = BEESU_BOOLEAN_TRUE;
            }
            if(first_valid_arg_name_of(arg, "f") || strcmp(arg,"--fast") == 0)
            {
                found = BEESU_BOOLEAN_TRUE;
                fast = BEESU_BOOLEAN_TRUE;
            }
            if(first_valid_arg_name_of(arg, "s"))
            {
                found = BEESU_BOOLEAN_TRUE;
                shell = argv[++i];
                if(shell == NULL)
                {
                    shell = (char *)const_shell;
                    i--;
                }
                else
                {
                    if(strlen(shell) > 0)
                    {
                        if(shell[0] == '-')
                        {
                            shell = (char *)const_shell;
                            i--;
                        }
                    }
                    else
                    {
                        shell = (char *)const_shell;
                        i--;
                    }
                }
            }
            if(arg[0] != '-')
            {
                found = BEESU_BOOLEAN_TRUE;
                local_params = 0;//this is the beginning of an applicaiton name!!
            }
            if(!found || first_invalid_arg_name_not_of(arg, const_valid_args) != NULL)
            {
                if(first_invalid_arg_name_not_of(arg, const_valid_args) == NULL)
                {
                    arg_error(0, argv[0], arg);
                }
                else
                {
                    f_read_buffer = (char*)malloc(4); //f_read_buffer->recycled variable
                    f_read_buffer[0] = '-';
                    f_read_buffer[1] = first_invalid_arg_name_not_of(arg, const_valid_args)[0];
                    f_read_buffer[2] = '\0';
                    arg_error(0, argv[0], f_read_buffer);
                    free(f_read_buffer);
                }
                return EXIT_FAILURE;
            }
        }
        if(local_params == 0)
        {
            external_params = i;
            break;//Quit local parsing
        }
        if(local_params == 100)
        {
            local_params = 0;
        }
    }

    if(external_params != NO_EXTERNAL_ARGS || shell != NULL)
    {
        add_argument(&arguments, "su");
        if(simulate_login)
        {
            add_argument(&arguments, "-l");
        }
        if(preserve_environment)
        {
            add_argument(&arguments, "-m");
        }
        if(fast)
        {
            add_argument(&arguments, "-f");
        }
        if(shell != NULL)
        {
            add_argument(&arguments, "-s");
            add_argument(&arguments, shell);
        }
        if(external_params != NO_EXTERNAL_ARGS)
        {
            add_argument(&arguments, "-c");
            for(i = external_params; i < argc; i++)
            {
                arg = argv[i];
                add_argument(&arguments_su, arg);
            }
        }
    }

    arguments_su_memory = (char*)malloc(arguments_su.size + arguments_su.count + 1);
    if(arguments_su_memory == NULL)
    {
        exit(EXIT_FAILURE);
    }

    arguments_su_memory[0]='\0';//strcpy(arguments_su_memory, "");

    for(i = 0; i < arguments_su.count; i++)
    {
        strcat(arguments_su_memory, arguments_su.items[i]);
        if(i!=arguments_su.count-1)
        {
            strcat(arguments_su_memory, " ");
        }
    }

    f_config = fopen(const_configuration, "r");
    if(f_config == NULL)
    {
        fprintf(stderr, "Unable to open beesu configuration file \'%s\'\n",const_configuration);
        free(arguments_su_memory);
        return EXIT_FAILURE;
    }

    f_read_buffer = (char*)malloc(READ_BUFFER_SIZE);
    if(f_read_buffer == NULL)
    {
        exit(EXIT_FAILURE);
    }

    f_block_name[0]='\0';//strcpy(f_block_name, "");

    while(!feof(f_config))
    {
        if(fgets(f_read_buffer,READ_BUFFER_SIZE,f_config)!=NULL)
        {
            i = strlen(f_read_buffer);
            while(i > 0)
            {
                i--;
                if(f_read_buffer[i]=='\n' || f_read_buffer[i]=='\r')
                {
                    f_read_buffer[i] = '\0';
                }
                else
                {
                    break;
                }
            }
            if(f_read_buffer[0]==';' || f_read_buffer[0]=='#')
            {
                //it's a comment
            }
            else
            {
                if(strcmp(f_read_buffer,"<allow>")==0)
                {
                    strcpy(f_block_name, "allow");
                    if(print_configuration_file_and_quit)
                        printf("List of allowed commands:\n");
                }
                else
                if(strcmp(f_read_buffer,"</allow>")==0 && strcmp(f_block_name, "allow")==0)
                {
                    strcpy(f_block_name, "");
                    if(print_configuration_file_and_quit)
                        printf("End of allowed commands list.\n");
                }
                else
                {
                    if(strcmp(f_block_name, "allow")==0)
                    {
                        if(strlen(f_read_buffer) > 0)
                        {
                            if(strcmp(f_read_buffer,"*")==0)
                            {
                                command_in_whitelist = BEESU_BOOLEAN_TRUE;
                                if(print_configuration_file_and_quit)
                                    printf("*ANY*\n");
                            }
                            else
                            {
                                if(print_configuration_file_and_quit)
                                    printf("<%s>\n",f_read_buffer);
                            }
                            if(strcmp(f_read_buffer,arguments_su_memory)==0)
                            {
                                command_in_whitelist = BEESU_BOOLEAN_TRUE;
                            }
                        }
                    }
                    else
                    {
                        //outside any blocks or unknown...
                    }
                }
            }
        }
    }
    free(f_read_buffer);
    fclose(f_config);

    if(print_configuration_file_and_quit)
    {
        free(arguments_su_memory);
        return EXIT_SUCCESS;
    }

    if(arguments.count==0)
    {
        fprintf(stderr, "Warning: no commands. Nothing to do.\n");
    }
    else
    {
        if(arguments_su.count > 0)
        {
            if(compress_params)
            {
                add_argument(&arguments, arguments_su_memory);
            }
            else
            {
                for(i = 0; i < arguments_su.count; i++)
                {
                    add_argument(&arguments, arguments_su.items[i]);
                }
            }
        }
        add_argument(&arguments, NULL);
        if(!command_in_whitelist)
        {
            fprintf(stderr, "Unable to run \'%s\'.\nIt isn\'t in the allowed commands list.\n",
                                arguments_su_memory);
            free(arguments_su_memory);
            return EXIT_FAILURE;
        }
        if(local_verbose)
        {
            fprintf(stderr, "Exec: %s\n",const_su);
            for(i = 0; i < arguments.count-1; i++)
            {
                fprintf(stderr, "argv[%i]=<%s>\n", i, arguments.items[i]);
            }
        }
        exec_result = execv(const_su, arguments.items);
    }

    free(arguments_su_memory);

    return EXIT_SUCCESS;
}

void add_argument(struct s_argument *arguments, char *argument)
{
    arguments->items = realloc(arguments->items, (arguments->count+1)*sizeof(char*) );
    if(arguments->items == NULL)
    {
        exit(EXIT_FAILURE);
    }
    arguments->items[arguments->count] = argument;
    arguments->count++;
    if(argument != NULL)
        arguments->size += strlen(argument);
    return;
}

void arg_error(const int id, const char *me, const char *arg)
{
    switch(id)
    {
        case 0:
            fprintf(stderr, "%s: invalid option -- \'%s\'\n", me, arg);
            break;
        case 1:
            fprintf(stderr, "%s: option requires an argument -- \'%s\'\n", me, arg);
            break;
        case 2:
            fprintf(stderr, "%s: conflict of options -- \'%s\'\n", me, arg);
            break;
    }
    return;
}

const char *first_valid_arg_name_of(const char *arg, const char *names)
{
    int i;
    if(arg[0] == '-' && arg[1] != '-')
        for(i = 0; i < strlen(names); i++)
            if(strchr(arg + sizeof(char), names[i]) != NULL)
                return names + i;
    return NULL;
}

const char *first_invalid_arg_name_not_of(const char *arg, const char *names)
{
    int i;
    if(arg[0] == '-' && arg[1] != '-')
        for(i = 1; i < strlen(arg); i++)
            if(strchr(names, arg[i]) == NULL)
                return arg + i;
    return NULL;
}


