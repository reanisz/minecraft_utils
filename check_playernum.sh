#!/bin/bash

ROOT=$(cd $(dirname $0);pwd)
cd $ROOT

source ./load_settings.sh

PLAYER_NUM=0
if ./minecraft.sh is_running; then
    PLAYER_NUM=`./minecraft.sh get_players_num`
fi

DATE=`date +%Y-%m-%d-%H:%M:%S`

echo "$DATE $PLAYER_NUM" >> /tmp/log_minecraft_playernum

ROW_NUM=`tail -n $SERVER_SHUTDOWN_COUNT /tmp/log_minecraft_playernum | wc -l`

if [[ $SERVER_SHUTDOWN_COUNT -ne $ROW_NUM ]]; then
    exit 
fi

if tail -n $SERVER_SHUTDOWN_COUNT /tmp/log_minecraft_playernum | cut -d ' ' -f 2 | grep -v '^0$' > /dev/null 2> /dev/null; then
    # 0じゃない行がある = 計測$SERVER_SHUTDOWN_COUNT回以内に1人以上参加者が居た
    :
else
    # 0じゃない行がない = 計測$SERVER_SHUTDOWN_COUNT回以内に誰もログインしていない
    if ./minecraft.sh is_running; then
        ./minecraft.sh stop
        sudo shutdown -h +5 
        while ./minecraft.sh is_running; do
            sleep 30
        done
        sudo shutdown -h now
    else
        sudo shutdown -h now
    fi
fi
