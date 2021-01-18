#!/bin/bash

set -e

DESTROY_VM=0
IMAGE=0
TEMPLATE=0
ENVIRONMENT_FILE=vm.env

HELP() {
  cat << EOT
Creates a Cloud-Init VM template with qemu-guest-agent installed for use with Proxmox.

Requirements:
  libguestfs-tools

Usage: $(basename $0) [-itd] [-e FILE] [-h]
  -i        Create image with qemu-guest-agent installed
  -t        Create Proxmox template from image
  -d        Destroy the VM if it exists
  -e FILE   Path to the environment file
  -h        Display this help and exit
EOT
}

USAGE() {
  echo "Usage: $(basename $0) [-itd] [-e FILE] [-h]"
  echo "Try '$(basename $0) -h' for more information"
}

createImage() {
  if [[ ! -r /boot/vmlinuz-$(uname -r) ]]; then
    echo "The kernel must be readable by non-root users to use libguestfs."
    sudo chmod 0644 /boot/vmlinuz-$(uname -r)
  fi

  wget $CLOUD_IMG -O $LOCAL_IMAGE

  virt-customize -a $LOCAL_IMAGE --install qemu-guest-agent
  virt-sysprep -a $LOCAL_IMAGE --enable logfiles,machine-id,package-manager-cache

  scp $LOCAL_IMAGE $PVE_HOST:$PVE_IMAGE
  rm $LOCAL_IMAGE
}

createTemplate() {
  ssh -q $PVE_HOST << EOT
    qm status $VM_ID > /dev/null

    if [ $? -eq 0 ]; then
      if [ $DESTROY_VM -eq 1 ]; then
        qm destroy $VM_ID
      else
        printf "\nVM $VM_ID already exists\n\n"
        exit 1
      fi
    fi

    qm create $VM_ID --name $VM_NAME --memory 2048 --cores 2 --serial0 socket --vga none --ide2 local-lvm:cloudinit --ostype l26 --pool $VM_POOL --agent 1
    qm importdisk $VM_ID $PVE_IMAGE local-lvm
    qm set $VM_ID --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-$VM_ID-disk-0
    qm set $VM_ID --boot c --bootdisk scsi0
    qm template $VM_ID
EOT
}

NUMARGS=$#
if [ $NUMARGS -eq 0 ]; then
  USAGE
  exit 0
fi

while getopts :hitde: opt; do
  case $opt in
    h)
      HELP
      ;;
    i)
      IMAGE=1
      ;;
    t)
      TEMPLATE=1
      ;;
    d)
      DESTROY_VM=1
      ;;
    e)
      ENVIRONMENT_FILE=$OPTARG
      ;;
    \?)
      USAGE
      exit 0
      ;;
    :)
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      exit 0
      ;;
  esac
done

shift $((OPTIND -1))

source $ENVIRONMENT_FILE

if [ $IMAGE -eq 1 ]; then
  createImage
fi
if [ $TEMPLATE -eq 1 ]; then
  createTemplate
fi