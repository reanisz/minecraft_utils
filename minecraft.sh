#!/bin/bash

source ./default_settings.conf
if [[ -f ~/.minecraft.conf ]]; then
    source ~/.minecraft.conf
fi

ROOT=$(cd $(dirname $0);pwd)

screen -ls | grep "minecraft" > /dev/null 2> /dev/null
IS_RUNNING=$?

function require(){
    case $1 in
        running)
            if [[ $IS_RUNNING != 0 ]]; then
                echo "Minecraft is not running."
                exit 1
            fi
            ;;
        stopped)
            if [[ $IS_RUNNING == 0 ]]; then
                echo "Minecraft is already running."
                exit 1
            fi
            ;;
        *)
            echo "An unexcepted error has occurred."
            exit 1
            ;;
    esac
}

function send_command(){
    eval "screen -S $SESSION_NAME -p 0 -X eval 'stuff \"$1\015\"'"
}
function send_message(){
    echo "Send Message: $1"
    send_command "say $1"
}

function cmd_start(){
    require stopped
    echo "Start minecraft."
    screen -AmdS $SESSION_NAME $ROOT/minecraft_loop.sh
}
function cmd_stop(){
    require running
    echo "Stop minecraft."
    touch /tmp/stop_minecraft
    send_command "stop"
}
function cmd_help(){
    echo "This is help."
}
function cmd_is_running(){
    exit $IS_RUNNING
}

command=$1
shift

case $command in
    start)
        cmd_start
        ;;
    stop)
        cmd_stop
        ;;
    send_message)
        send_message "$@"
        ;;
    is_running)
        cmd_is_running
        ;;
    *)
        cmd_help
        ;;
esac

