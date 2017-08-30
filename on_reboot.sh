#!/bin/bash

ROOT=$(cd $(dirname $0);pwd)
cd $ROOT

# 最新の設定に更新する
git fetch
git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)

rm /tmp/log_minecraft_playernum

# instanceを作り直すと /etc/hosts が変わるかもしれない
sed -i -e "1s/ip-.*//g" /etc/hosts
sed -i -e "1s/$/ $(hostname)/g" /etc/hosts

./mount_ebs.sh
./minecraft.sh start
