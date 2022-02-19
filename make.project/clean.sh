#!/bin/bash

echo "Persistently unmounting T_SYSROOT related mounts..."
echo "This section will ask for your sudo password."
for mnt in $(mount | grep T_SYSROOT | awk '{ print $3; }'); do 
	until sudo umount $mnt; do 
		echo "TRYING TO UNMOUNT $mnt"; sleep 1; 
	done; 
done

chown -R $1 ${project_root}

echo "Clearing Artifacts ('${artifacts_dir}')..."
rm -vRf ${artifacts_dir}

# recreate for structure integ.
mkdir -p ${artifacts_dir}
touch ${artifacts_dir}/DONT_DELETE.txt
chown -R $1 ${artifacts_dir}

echo "Artifacts cleared."
