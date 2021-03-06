#!/bin/bash

# closely aligns with LFS Ch g 8-iso

# fix an issue with open files limit on some hosts
ulimit -l unlimited
#ulimit -n 10240 
ulimit -c unlimited

echo "Bootstrapping from MAKE to REX..."

# install any remaining dependencies
# apt-get install newt

# Executes rex from within the shell.

${artifacts_dir}/rex/rex \
	-c ${rex_dir}/plans/x86_64/rex.config \
	-p ${rex_dir}/plans/x86_64/stage4.plan

retVal=$?



