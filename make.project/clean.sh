#!/bin/bash

# deprecated
#echo "Persistently unmounting T_SYSROOT related mounts..."
#echo "This section will ask for your sudo password."
#for mnt in $(mount | grep T_SYSROOT | awk '{ print $3; }'); do 
#	until sudo umount $mnt; do 
#		echo "TRYING TO UNMOUNT $mnt"; sleep 1; 
#	done; 
#done

echo "Clearing Artifacts ('${artifacts_dir}')..."
rm -vRf ${artifacts_dir}

# recreate for structure integ.
mkdir -p ${artifacts_dir}
touch ${artifacts_dir}/DONT_DELETE.txt
chmod -R 777 ${artifacts_dir}

echo "Artifacts cleared."
