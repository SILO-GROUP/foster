#!/bin/bash

# downloads sources for various packages necessary 

pushd ${patches_dir} 1>/dev/null 2>/dev/null

md5sum -c ${config_dir}/patches/10.1_patches_md5sums.txt
err=$?
popd 1>/dev/null 2>/dev/null

echo "Finished with exit code $err"
