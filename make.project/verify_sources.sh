#!/bin/bash

# downloads sources for various packages necessary 

pushd ${sources_dir} 1>/dev/null 2>/dev/null

md5sum --quiet -c ${config_dir}/sources/10.1_sources_md5sums.txt
err=$?
popd 1>/dev/null 2>/dev/null

echo "Finished with exit code $err"
