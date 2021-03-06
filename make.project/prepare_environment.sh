#!/bin/bash

# Prepares the host for the build process here.

# fix an issue with open files limit on some hosts
ulimit -l unlimited
ulimit -n 10240 
ulimit -c unlimited

echo "preparing environment"

# install any remaining dependencies
# apt-get install newt

# Executes rex from within the shell.

${artifacts_dir}/rex/rex \
	-c ${rex_dir}/plans/x86_64/rex.config \
	-p ${rex_dir}/plans/x86_64/prepare_env.plan

retVal=$?



