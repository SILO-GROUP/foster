#!/bin/bash

chown -R $1 ${patches_dir}
rm -Rfv ${patches_dir}
mkdir ${patches_dir}
touch ${patches_dir}/DONT_DELETE.md
chown -R $1 ${patches_dir}
