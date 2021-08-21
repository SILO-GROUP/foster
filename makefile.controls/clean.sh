#!/bin/bash

echo "Persistently unmounting T_SYSROOT related mounts..."
for mnt in $(mount | grep T_SYSROOT | awk '{ print $3; }'); do 
	until sudo umount $mnt; do 
		echo "TRYING TO UNMOUNT $mnt"; sleep 1; 
	done; 
done

echo "Clearing T_SYSROOT..."
sudo rm -Rf $workspace/T_SYSROOT
echo "Clearing logs..."
sudo rm -Rfv $workspace/logs
