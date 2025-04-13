#loginfo2() {
#
#    # Show info. use: loginfo Level [opts] [strs]
#
#    #echo args1: "$@"
#    local ARG NN TT
#    ARG=$1; NN="" ; TT=""
#    if [ $((VERBOSE)) -ge $((ARG)) ] ; then
#        shift
#        #echo args2: "$@"
#
#        while getopts 'net' opt; do
#
#            case $opt in
#                n)
#                    NN="$NN-n "
#                    ;;
#                e)
#                    NN="$NN-e "
#                    ;;
#                t)
#                    TT="1"
#                    ;;
#
#                ?)
#                    #echo no arg: $opt
#                    break
#                    ;;
#            esac
#        done
#
#        shift "$((OPTIND -1))"
#        if [ "$TT" == "" ] ; then
#            echo -n "$(ptime) "
#        fi
#        echo $NN "$*"
#    fi
#}

