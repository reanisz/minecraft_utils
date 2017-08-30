#!/bin/bash

ROOT=$(cd $(dirname $0);pwd)
cd $ROOT

source ./load_settings.sh

command=$1
shift

SINGLE_RUN=0
if [[ $command = "single_run" ]]; then
    SINGLE_RUN=1
fi

cd $MINECRAFT_DIR

while true
do
    if [[ -f /tmp/stop_minecraft ]]; then
        rm /tmp/stop_minecraft
        exit
    else
        $JAVA_COMMAND $JVM_OPTION \
            -Xms$JVM_OPTION_Xms -Xmx$JVM_OPTION_Xmx \
            -jar $JARFILE nogui
    fi

    if [[ $SINGLE_RUN == 1 ]]; then
        exit
    fi
done
