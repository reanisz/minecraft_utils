#!/bin/bash

source ./default_settings.conf

ROOT=$(cd $(dirname $0);pwd)

function send_command(){
    eval "screen -S $SESSION_NAME -p 0 -X eval 'stuff \"$1\015\"'"
}
function send_message(){
    send_command "say $1"
}

function start(){
    screen -AmdS $SESSION_NAME $ROOT/minecraft_loop
}
function stop(){
    touch /tmp/stop_minecraft
    send_command "stop"
}
