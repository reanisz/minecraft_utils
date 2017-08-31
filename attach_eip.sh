#!/bin/bash

# EBSをmountするスクリプト
# by http://qiita.com/web_se/items/6dc70a3d09b2e7dc5f28

ROOT=$(cd $(dirname $0);pwd)
cd $ROOT

source ./load_settings.sh

aws ec2 associate-address --allocation-id $SERVER_EIP_ALLOCATION_ID --instance-id $SERVER_INSTANCE_ID --private-ip-address $SERVER_PRIVATE_IP
