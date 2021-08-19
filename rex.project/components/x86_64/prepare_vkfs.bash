#!/bin/bash
# Prepares sysroot ownership and perms for chrooting
# print to stdout, print to log
# the path where logs are written to
# note: LOGS_ROOT is sourced from environment

APPNAME="CHROOT VFS SETUP"

# ISO 8601 variation
TIMESTAMP="$(date +%Y-%m-%d_%H:%M:%S)"

LOG_DIR="${LOGS_ROOT}/${APPNAME}-${TIMESTAMP}"

# the file to log to
LOGFILE="${APPNAME}.log"

logprint() {
	mkdir -p "${LOG_DIR}"
	echo "[$(date +%Y-%m-%d_%H:%M:%S)] [${APPNAME}] $1" \
	| tee -a "${LOG_DIR}/${LOGFILE}"
}

logprint "CHROOT VFS SETUP"

mkdir -pv ${T_SYSROOT}/{dev,proc,sys,run}
assert_zero $?

# source these majors and minors
logprint "Creating block device for console..."
mknod -m 600 ${T_SYSROOT}/dev/console c 5 1
assert_zero $?

# source these majors and minors
logprint "Create block device for null..."
mknod -m 666 ${T_SYSROOT}/dev/null c 1 3

logprint "Bind mounting /dev from host to chroot sysroot..."
mount -v --bind /dev ${T_SYSROOT}/dev
assert_zero $?

logprint "Bind mounting /dev/pts from host to chroot sysroot..."
mount -v --bind /dev/pts ${T_SYSROOT}/dev/pts
assert_zero $?

logprint "mounting proc filesystem from to chroot sysroot..."
mount -v -t proc proc ${T_SYSROOT}/proc
assert_zero $?

logprint "mounting /sys filesystem from to chroot sysroot..."
mount -v -t sysfs sysfs ${T_SYSROOT}/sys
assert_zero $?

logprint "mounting tmpfs/run filesystem from to chroot sysroot..."
mount -v -t tmpfs tmpfs ${T_SYSROOT}/run
assert_zero $?

# not a symlink on ubuntu
if [ -h ${T_SYSROOT}/dev/shm ]; then
	mkdir -vp ${T_SYSROOT}/$(readlink ${T_SYSROOT})/dev/shm
	assert_zero $?

fi
