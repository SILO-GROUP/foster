#!/bin/bash

# fix an issue with open files limit on some hosts
ulimit -l unlimited
ulimit -n 10240 
ulimit -c unlimited

# install any remaining dependencies
# apt-get install newt

# Executes rex from within the shell.
${artifacts}/rex \
	-c ${rex_dir}/plans/x86_64/rex.config \
	-p ${rex_dir}/plans/x86_64/stage1.plan

retVal=$?



