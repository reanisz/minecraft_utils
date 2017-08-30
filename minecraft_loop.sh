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

cd $MINECRAFT_DIR

while true
do
    if [[ -f /tmp/stop_minecraft ]]; then
        rm /tmp/stop_minecraft
        exit
    else
        $JAVA_COMMAND $JVM_OPTION -jar $JARFILE nogui
    fi
done
