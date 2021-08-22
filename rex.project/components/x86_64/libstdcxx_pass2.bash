#!/bin/bash
# bootstraps a build of libstdcxx from chroot context

APPNAME="LIBSTDCXX PASS2"

# ISO 8601 variation
TIMESTAMP="$(date +%Y-%m-%d_%H:%M:%S)"

# the file to log to
LOGFILE="${APPNAME}.log"

LOG_DIR="${LOGS_ROOT}/${APPNAME}-${TIMESTAMP}"

logprint() {
	mkdir -p "${LOG_DIR}"
	echo "[$(date +%Y-%m-%d_%H:%M:%S)] [${APPNAME}] $1" \
	| tee -a "${LOG_DIR}/${LOGFILE}"
}

assert_zero() {
	if [[ "$1" -eq 0 ]]; then 
		return
	else
		exit $1
	fi
}

#cp `which getopt` ${M_SYSROOT}/tmp/
#assert_zero $?

# apparently some kind of nesting bug w/ Rex and file descriptors
logprint "bootstrapping an in-chroot build of libstdcxx pass2"
chroot --userspec=root:root "$1/T_SYSROOT" /bin/bash -c "source /opt/foster/rex.project/environments/x86_64/chroot_bootstrap.bash && /opt/foster/rex.project/components/x86_64/gcc.bash --libstdcxx_pass2"

assert_zero $?
