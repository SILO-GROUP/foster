#!/bin/bash

# fix an issue with open files limit on some hosts
ulimit -l unlimited
ulimit -n 10240 
ulimit -c unlimited

# install any remaining dependencies
# apt-get install newt
assert_zero() {
	if [[ "$1" -eq 0 ]]; then 
		return
	else
		exit $1
	fi
}

# Executes rex from within the chroot
chroot $1/T_SYSROOT /bin/bash -c "cd /opt/foster/rex.project; /usr/local/bin/rex -c /opt/foster/rex.project/plans/x86_64/rex.config -p /opt/foster/rex.project/plans/x86_64/stage2.plan"
assert_zero $?
		
