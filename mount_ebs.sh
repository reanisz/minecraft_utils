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

INSTANCE_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`

while [ "$state" != "running" ]
do
result=`aws ec2 describe-instances --filters Name=instance-id,Values=$INSTANCE_ID | jq '.Reservations[].Instances[].State.Name' | grep running`
state=`echo $result | cut -d '"' -f 2`
echo $state
done

if [ ! -e /dev/xvdf ]; then
    # attach to the EBS volume and wait for attachment to complete
    aws ec2 attach-volume  --volume-id $SERVER_VOLUME_ID --instance-id $INSTANCE_ID --device  /dev/sdf
fi

while [ ! -e /dev/xvdf ]
do
  echo "Waiting for disk to appear.."
  sleep 3
done

# mount it
sudo chown ec2-user:ec2-user /mc_server
sudo mount -t ext4 /dev/xvdf /mc_server/
