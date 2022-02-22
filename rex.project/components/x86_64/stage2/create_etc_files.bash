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

logprint "Creating etc files..."

cp -pvf ${CONFIG_DIR}/etc/passwd ${T_SYSROOT}/etc/passwd
assert_zero $?

cp -pvf ${CONFIG_DIR}/etc/group ${T_SYSROOT}/etc/group
assert_zero $?

cp -pvf ${CONFIG_DIR}/etc/hosts ${T_SYSROOT}/etc/hosts
assert_zero $?

