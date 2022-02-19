#!/bin/bash

chown -R $1 ${sources_dir}
rm -Rfv ${sources_dir}
mkdir -p ${sources_dir}
touch ${sources_dir}/DONT_DELETE.md
chown -R $1 ${sources_dir}

