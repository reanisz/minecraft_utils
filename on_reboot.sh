#!/bin/bash

ROOT=$(cd $(dirname $0);pwd)
cd $ROOT

./mount_ebs.sh
./minecraft.sh start
