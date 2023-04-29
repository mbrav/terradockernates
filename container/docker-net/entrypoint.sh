#!/bin/sh

# Default script command
SCRIPT_COMMAND=run

# Args
docker_hosts="localhost"
interval_arg=1
count_arg=5


# Display Help
help() {
    echo "ABOUT"
    echo "This is a entrypoint script for docker-net"
    echo
    echo "SYNTAX"
    echo './entrypoint.sh [-h] [-i] [ARG] [run] [ping] [ARG]'
    echo
    echo "COMMANDS"
    echo "run                         Run script as an infinite loop"
    echo "ping                 [ARG]  Ping hosts passed as a space separated argument. Default: $docker_hosts"
    echo
    echo "OPTIONS"
    echo "-h   --help                 Print this Help."
    echo "-i   --interval      [ARG]  Specify interval in seconds. Default: $interval_arg"
    echo "-c   --count         [ARG]  Specify count argument. Default: $count_arg"
    echo
}

# ARG parser
if [ $# -eq 0 ]; then
    # If no arguments, display help
    help
else
    while [ $# -gt 0 ]; do
        case $1 in
            --help|-h)
                help
                shift # shift argument
                exit 0
            ;;
            --interval|-i)
                interval_arg="$2"
                shift # shift argument
                shift # shift value
            ;;
            --count|-c)
                count_arg="$2"
                shift # shift argument
                shift # shift value
            ;;
            run)
                SCRIPT_COMMAND=run
                shift # shift argument
            ;;
            ping)
                SCRIPT_COMMAND=ping
                shift # shift argument
                # If arg value not empty, redefine value with passed argument 
                [ -n "$1" ] && docker_hosts="$1" && shift  # shift value
            ;;
            -*)
                echo "Unknown option $1"
                exit 1
            ;;
            *)
                echo "Unknown argument $1"
                echo 'If you want to pass an argument with spaces'
                echo 'pass the argument like this: "my argument"'
                exit 1
            ;;
        esac
    done
fi

run_cmd() {
    # Run program in a infinite loop
    echo "Running infinite loop with interval $interval_arg"
    count=0
    while true; do
        count=$(( count + 1 ))
        echo "Loop $count. Press [CTRL+C] to stop.."
        sleep $interval_arg
    done
}

ping_cmd() {
    # Ping all specified hosts
    echo "Running ping command with interval $interval_arg seconds for hosts: $docker_hosts"
    count=0
    while true; do
        count=$(( count + 1 ))
        echo "Ping $count. Press [CTRL+C] to stop.."

        for host in $docker_hosts; do
            ping_result=$(ping -c "$count_arg" "$host")
            echo "Pinged host $host $count_arg times:"
            echo "$ping_result"
        done

        sleep $interval_arg
    done
}

# Run Command parser
case $SCRIPT_COMMAND in
    run)
        run_cmd
    ;;
    ping)
        ping_cmd
    ;;
    *)
        echo "Unknown command to run $1"
        echo 'Please see list of commands that you can run in help'
        exit 1
    ;;
esac
