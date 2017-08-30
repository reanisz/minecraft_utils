#!/bin/bash

ROOT=$(cd $(dirname $0);pwd)
cd $ROOT

source ./load_settings.sh

PLAYER_NUM=`./minecraft.sh get_players_num`

NAMESPACE="Minecraft"
DIMENSIONS="InstanceId=$SERVER_INSTANCE_ID"
/usr/bin/aws cloudwatch put-metric-data --region $SERVER_REGION --namespace "${NAMESPACE}" --dimensions ${DIMENSIONS} --unit Count --metric-name "PlayerNum" --value $PLAYER_NUM
