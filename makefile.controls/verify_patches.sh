#!/bin/bash

# downloads sources for various packages necessary 

pushd ${workspace}/staging/patches/ 1>/dev/null 2>/dev/null

md5sum --quiet -c ./10.1_patches_md5sums.txt
err=$?
popd 1>/dev/null 2>/dev/null

echo "Finished with exit code $err"
