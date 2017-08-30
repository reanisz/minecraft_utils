#!/bin/bash

# EBSをmountするスクリプト
# by http://qiita.com/web_se/items/6dc70a3d09b2e7dc5f28

ROOT=$(cd $(dirname $0);pwd)
cd $ROOT

source ./default_settings.conf
if [[ -f ~/.minecraft.conf ]]; then
    source ~/.minecraft.conf
fi
if [[ -f .minecraft.conf ]]; then
    source .minecraft.conf
fi
source ./get_aws_conf.sh

export AWS_DEFAULT_REGION="$SERVER_REGION"

aws ec2 attach-network-interface --instance-id $SERVER_INSTANCE_ID --network-interface-id $SERVER_EIP_ID --device-index 1
