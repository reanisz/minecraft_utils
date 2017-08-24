#!/bin/bash

if [[ -f ~/.minecraft.conf ]]; then
    source ~/.minecraft.conf
fi

cd $MINECRAFT_DIR

while true
do
    if [[ -f /tmp/stop_minecraft ]]; then
        rm /tmp/stop_minecraft
        exit
    else
        java $JVM_OPTION -jar $JARFILE nogui
    fi
done
