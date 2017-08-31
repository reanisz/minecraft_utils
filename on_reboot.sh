#!/bin/bash

ROOT=$(cd $(dirname $0);pwd)
cd $ROOT

source ./load_settings.sh

# 最新の設定に更新する
git fetch origin $(git rev-parse --abbrev-ref HEAD)
git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)

rm /tmp/log_minecraft_playernum

# instanceを作り直すと /etc/hosts が変わるかもしれない
sed -i -e "1s/ip-.*//g" /etc/hosts
sed -i -e "1s/$/ $(hostname)/g" /etc/hosts

sudo cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

./mount_ebs.sh
./attach_eip.sh
./minecraft.sh start
