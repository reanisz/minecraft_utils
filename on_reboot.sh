#!/bin/bash

ROOT=$(cd $(dirname $0);pwd)

$ROOT/mount_ebs.sh
$ROOT/minecraft.sh start
