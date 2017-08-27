#!/bin/bash

source ./default_settings.conf
if [[ -f ~/.minecraft.conf ]]; then
    source ~/.minecraft.conf
fi
if [[ -f .minecraft.conf ]]; then
    source .minecraft.conf
fi

ROOT=$(cd $(dirname $0);pwd)

PLAYER_NUM='$ROOT/minecraft.sh get_players_num'

/opt/aws/bin/mon-put-data --metric-name "Minecraft_PlayerNum" --namespace "Custom Metrix" --dimensions "InstanceId=$SERVER_INSTANCE_ID" --value "$PLAYER_NUM" --unit "Count"

