#!/bin/bash

#Creates a Proxmox cloud-init ready template from a cloudimg

set -e

IMAGE=/var/lib/vz/template/iso/ubuntu-20.04-server-cloudimg-amd64.img
NAME=ubuntu-2004-cloudinit-template
ID=9000

wget $URL -O $IMAGE

qm create $ID --name $NAME --memory 2048 --cores 2 --serial0 socket --vga none --ide2 local-lvm:cloudinit --ostype l26 --pool terraform --agent 1
qm importdisk $ID $IMAGE local-lvm
qm set $ID --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-$ID-disk-0
qm set $ID --boot c --bootdisk scsi0
qm template $ID