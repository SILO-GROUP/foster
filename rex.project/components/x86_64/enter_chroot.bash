#!/bin/bash
# Prepares sysroot ownership and perms for chrooting
# print to stdout, print to log
# the path where logs are written to
# note: LOGS_ROOT is sourced from environment

APPNAME="CHROOT VFS SETUP"

# ISO 8601 variation
TIMESTAMP="$(date +%Y-%m-%d_%H:%M:%S)"

LOG_DIR="${LOGS_ROOT}/${APPNAME}-${TIMESTAMP}"

logprint() {
	mkdir -p "${LOG_DIR}"
	echo "[$(date +%Y-%m-%d_%H:%M:%S)] [${APPNAME}] $1" \
	| tee -a "${LOG_DIR}/${LOGFILE}"
}

logprint "Chrooting into your new sysroot..."
chroot "${T_SYSROOT}" /usr/bin/env -i \
	HOME=/root \
	TERM="${TERM}" \
	PS1='\n[ \u @ (CHROOT) ] << \w >> \n\n[- ' \
	PATH=/bin:/usr/bin:/sbin:/usr/sbin \
	/bin/bash --login +h

logprint "Thanks for hanging in there!"
