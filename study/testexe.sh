# Execute items with pre / post display

export SUL="test"
export SULERR=$SUL/log_err; SULOUT=$SUL/log_out

exec_items() {
    echo "would exec: getargx ibreak=$1 && tmpshell  $FOUNDVAR $ "
    echo "would exec: loginfo 0 -n Starting $2 ... "
    shift; shift
    for AA in "$@" ; do
        echo "would exec: $AA  >>$SULOUT 2>>$SULERR &"
    done

    echo would exec: "getargy 'isleep' && sleep $FOUNDVAL"
    echo would exec: loginfo 0 -t -e " \033[32;1mOK\033[0m"
}

exec_items  "sshd" "sshd" \
            "pre" "/usr/bin/sshd hello" "post"
