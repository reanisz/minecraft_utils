#!/bin/bash

source ./default_settings.conf
if [[ -f ~/.minecraft.conf ]]; then
    source ~/.minecraft.conf
fi
if [[ -f .minecraft.conf ]]; then
    source .minecraft.conf
fi

ROOT=$(cd $(dirname $0);pwd)

PLAYER_NUM=`$ROOT/minecraft.sh get_players_num`

NAMESPACE="Minecraft"
DIMENSIONS="InstanceId=$SERVER_INSTANCE_ID"
/usr/bin/aws cloudwatch put-metric-data --region $SERVER_REGION --namespace "${NAMESPACE}" --dimensions ${DIMENSIONS} --unit Count --metric-name "PlayerNum" --value $PLAYER_NUM
