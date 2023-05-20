#! /bin/bash


# Here is the name of the virtual box to be created
MACHINE_NAME=$1

VBoxManage showvminfo $MACHINE_NAME > /dev/null

if [ $? -eq 0 ]; then exit; fi

set -xueo pipefail

trap "echo Undoing $MACHINE_NAME; vboxmanage unregistervm --delete $MACHINE_NAME" ERR
 
# Location of the iso file
ISO=$2

# Create the vm slot
VBoxManage createvm --name $MACHINE_NAME --ostype "Fedora_64" --register

# Modify vm slot with network and hardware components
VBoxManage modifyvm $MACHINE_NAME --memory 1024 --cpus=1 --graphicscontroller=vmsvga 
VBoxManage modifyvm $MACHINE_NAME --nic1=natnetwork --nat-network1=ansibleNet



