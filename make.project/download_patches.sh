#!/bin/bash

# downloads sources for various packages necessary 

#wget \
#	-q \
#	--show-progress \
#	--input-file=${workspace}/staging/patches/10.1_patches.txt \
#	--continue \
#	--directory-prefix=${workspace}/staging/patches

echo "Clearing existing patches..."
rm -Rf ${patches_dir}

git clone https://source.silogroup.org/SURRO-Linux/patches.git ${patches_dir}

echo "Download returned with exit code '$?'."
