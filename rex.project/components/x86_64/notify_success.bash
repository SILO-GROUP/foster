#!/bin/bash
# Prepares sysroot ownership and perms for chrooting
# print to stdout, print to log
# the path where logs are written to
# note: LOGS_ROOT is sourced from environment

APPNAME="NOTIFY_SUCCESS"

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

logprint "You may now chroot into your new sysroot by typing 'make enter_chroot'."
logprint "Thanks for hanging in there!"
