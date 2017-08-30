#!/bin/bash

ROOT=$(cd $(dirname $0);pwd)
cd $ROOT

rm /tmp/log_minecraft_playernum

# instanceを作り直すと /etc/hosts が変わるかもしれない
sed -i -e "1s/ip-.*//g" /etc/hosts
sed -i -e "1s/$/ $(hostname)/g" /etc/hosts

./mount_ebs.sh
./minecraft.sh start
