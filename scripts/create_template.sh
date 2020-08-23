#!/bin/bash

# Creates a cloud-init image with qemu-guest-agent installed.
# The image will be copied to the Proxmox host, and used to create a VM template.

createImage() {
  if [[ ! -r /boot/vmlinuz-$(uname -r) ]]; then
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
      if [ $FORCE -eq 1 ]; then
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

ENVIRONMENT=vm.env
FORCE=0
IMAGE=1
TEMPLATE=1

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -e)
      ENVIRONMENT="$2"
      shift
      shift
      ;;
    -f)
      FORCE=1
      shift
      ;;
    -i)
      IMAGE=1
      TEMPLATE=0
      shift
      ;;
    -t)
      IMAGE=0
      TEMPLATE=1
      shift
      ;;
  esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters

source $ENVIRONMENT

if [ $IMAGE -eq 1 ]; then
  createImage
fi
if [ $TEMPLATE -eq 1 ]; then
  createTemplate
fi