#!/bin/bash

# closely aligns with LFS Ch 6-8.11.1

# this will change to be 6-7, with stage3 being 7-8, and stage 4 being 8-iso

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
	-p ${rex_dir}/plans/x86_64/stage2.plan

retVal=$?



