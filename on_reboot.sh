#!/bin/bash

ROOT=$(cd $(dirname $0);pwd)
cd $ROOT

rm /tmp/log_minecraft_playernum

./mount_ebs.sh
./minecraft.sh start
