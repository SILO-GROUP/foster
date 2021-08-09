#!/bin/bash

# fix an issue with open files limit on some hosts
ulimit -l unlimited
ulimit -n 10240 
ulimit -c unlimited

# install any remaining dependencies
# apt-get install newt

# Executes rex from within the shell.
/usr/bin/rex \
	-c /opt/foster/rex.project/plans/x86_64/rex.config \
	-p /opt/foster/rex.project/plans/x86_64/rex.plan

retVal=$?



