#!/bin/bash

#Creates an Ubuntu 20.04 cloudimg with qemu-guest-agent installed

set -e

URL=https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img
LOCAL_IMAGE=~/img/ubuntu-20.04-server-cloudimg-amd64.img
REMOTE_IMAGE=/var/lib/vz/template/iso/ubuntu-20.04-server-cloudimg-amd64.img
PVE_HOST=root@192.168.1.42

if [[ ! -r /boot/vmlinux-$(uname -r) ]]; then
  sudo chmod 0644 /boot/vmlinux-$(uname -r)
fi

wget $URL -O $LOCAL_IMAGE

virt-customize -a $LOCAL_IMAGE --install qemu-guest-agent
virt-sysprep -a $LOCAL_IMAGE --enable logfiles,machine-id,package-manager-cache

scp $LOCAL_IMAGE $PVE_HOST:$REMOTE_IMAGE