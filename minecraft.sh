#!/bin/bash

ROOT=$(cd $(dirname $0);pwd)
cd $ROOT

source ./default_settings.conf
if [[ -f ~/.minecraft.conf ]]; then
    source ~/.minecraft.conf
fi
if [[ -f .minecraft.conf ]]; then
    source .minecraft.conf
fi
source ./get_aws_conf.sh

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
    pre_log_len=`wc -l "$MINECRAFT_DIR/logs/latest.log" | awk '{print $1}'`
    eval "screen -p 0 -S minecraft -X eval 'stuff \"$1\"\015'"
    sleep .1
    tail -n $[`wc -l "$MINECRAFT_DIR/logs/latest.log" | awk '{print $1}'`-$pre_log_len] "$MINECRAFT_DIR/logs/latest.log"
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
function cmd_send_message(){
    require running
    send_message "$@"
}
function cmd_command(){
    require running
    send_command "$@"
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
        cmd_send_message "$@"
        ;;
    is_running)
        cmd_is_running
        ;;
    command)
        cmd_command "$@"
        ;;
    get_players)
        cmd_command "list"
        ;;
    get_players_num)
        if [[ $IS_RUNNING == 0 ]]; then
            PLAYER_NUM=`cmd_command "list" | perl -nle 'if(/There are (\d+)\/(\d+) players online/){ print $1;}'`
            if [[ $PLAYER_NUM == "" ]]; then
                echo "0"
            else
                echo $PLAYER_NUM
            fi
        else
            echo "0"
        fi
        ;;
    *)
        cmd_help
        ;;
esac

