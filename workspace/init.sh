#!/bin/bash

# fix an issue with open files limit on some hosts
ulimit -l unlimited
ulimit -n 10240 
ulimit -c unlimited

# install any remaining dependencies
# apt-get install newt


# Executes rex from within the shell.
/usr/bin/rex -v \
	-c /opt/foster/rex.project/foster.rex.config \
	-p /opt/foster/rex.project/plans/x86_64/foster.plan

retVal=$?



if [ $retVal -ne 0 ]; then
	# The autostarted version of rex failed.	
	printf "\n\n***\n***\tFOSTER FAILED\n***\n"
	printf "\nFix the project on the host filesystem and re-run:\n"
	printf "\n/opt/foster/init.sh\n"

	if [ ! -e debug_shell ]; then
		touch debug_shell
		printf "\n\nDropping to debug shell.\n"
		/bin/bash
	fi
fi
rm -f debug_shell
