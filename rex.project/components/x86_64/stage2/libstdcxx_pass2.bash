#!/bin/bash
# bootstraps a build of libstdcxx from chroot context

APPNAME="LIBSTDCXX PASS2"

# ISO 8601 variation
TIMESTAMP="$(date +%Y-%m-%d_%H:%M:%S)"

# the file to log to
LOGFILE="${APPNAME}.log"

LOG_DIR="$1/logs/scripts/${APPNAME}-${TIMESTAMP}"

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
chroot --userspec=root:root "${T_SYSROOT}" /bin/bash -c "source ${rex_dir}/environments/x86_64/chroot_bootstrap.bash && ${rex_dir}/components/x86_64/stage_1/gcc.bash --libstdcxx_pass2"

assert_zero $?
