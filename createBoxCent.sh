#! /bin/bash


# Name of the virtual box to be created
MACHINE_NAME=$1

VBoxManage showvminfo $MACHINE_NAME > /dev/null

if [ $? -eq 0 ]; then
	echo -e "$MACHINE_NAME VIRTUALBOX EXISTS ALREADY";	
	exit; fi

set -xueo pipefail

trap "echo Undoing $MACHINE_NAME; vboxmanage unregistervm --delete $MACHINE_NAME" ERR
 
# Location of the iso file
ISO=$2

# Create the vm slot
VBoxManage createvm --name $MACHINE_NAME --ostype "Linux_64" --register

# Modify vm slot with network and hardware components
VBoxManage modifyvm $MACHINE_NAME --memory 1024 --cpus=1 --graphicscontroller=vmsvga 
VBoxManage modifyvm $MACHINE_NAME --nic1=natnetwork --nat-network1=ansibleNet


# Create and Attach HD and ISO
VBoxManage createhd --filename `pwd`/../Machines/$MACHINE_NAME/"$MACHINE_NAME"_DISK.vdi --size 20000 --format VDI
VBoxManage storagectl $MACHINE_NAME --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach $MACHINE_NAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  `pwd`/../Machines/$MACHINE_NAME/"$MACHINE_NAME"_DISK.vdi
VBoxManage storagectl $MACHINE_NAME --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach $MACHINE_NAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $ISO
