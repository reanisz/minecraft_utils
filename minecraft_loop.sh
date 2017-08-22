#!/bin/bash

while true
do
    if [[ -f /tmp/stop_minecraft ]]; then
        rm /tmp/stop_minecraft
        exit
    else
        java $JVM_OPTION -jar $JARFILE.jar nogui
    fi
done
