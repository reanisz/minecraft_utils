#!/bin/bash

if [[ $RUNNING_ON_AWS == "yes" ]]; then
    SERVER_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    SERVER_INSTANCE_TYPE=$(curl -s http://169.254.169.254/latest/meta-data/instance-type)
    SERVER_PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

    if [[ $AUTO_FITTING_MEMORYSIZE == "yes" ]]; then
        case $SERVER_INSTANCE_TYPE in
            "t2.micro")
                JVM_OPTION_Xms="128M"
                JVM_OPTION_Xmx="256M"
                ;;
            "m4.large")
                JVM_OPTION_Xms="4000M"
                JVM_OPTION_Xmx="7000M"
                ;;
            "m4.xlarge")
                JVM_OPTION_Xms="8000M"
                JVM_OPTION_Xmx="15000M"
                ;;
            "m4.2xlarge")
                JVM_OPTION_Xms="16000M"
                JVM_OPTION_Xmx="30000M"
                ;;
            "c4.xlarge")
                JVM_OPTION_Xms="4000M"
                JVM_OPTION_Xmx="6500M"
                ;;
            "c4.2xlarge")
                JVM_OPTION_Xms="8000M"
                JVM_OPTION_Xmx="14000M"
                ;;
            *)
                :
                ;;
        esac
    fi
    export AWS_DEFAULT_REGION="$SERVER_REGION"
fi
