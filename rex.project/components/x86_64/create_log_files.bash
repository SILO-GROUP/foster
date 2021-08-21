#!/bin/bash
# Prepares sysroot ownership and perms for chrooting
# print to stdout, print to log
# the path where logs are written to
# note: LOGS_ROOT is sourced from environment

APPNAME="CREATE ETC FILES"

# ISO 8601 variation
TIMESTAMP="$(date +%Y-%m-%d_%H:%M:%S)"

LOG_DIR="${LOGS_ROOT}/${APPNAME}-${TIMESTAMP}"

logprint() {
	mkdir -p "${LOG_DIR}"
	echo "[$(date +%Y-%m-%d_%H:%M:%S)] [${APPNAME}] $1" \
	| tee -a "${LOG_DIR}/${LOGFILE}"
}

logprint "Creating log files..."

touch ${T_SYSROOT}/var/log/{btmp,lastlog,faillog,wtmp}
assert_zero $?

chgrp -v +13 ${T_SYSROOT}/var/log/lastlog
assert_zero $?

chmod -v 664 ${T_SYSROOT}/var/log/lastlog
assert_zero $?

chmod -v 600 ${T_SYSROOT}/var/log/btmp
assert_zero $?

