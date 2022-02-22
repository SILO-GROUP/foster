#!/bin/bash
# Prepares sysroot ownership and perms for chrooting
# print to stdout, print to log
# the path where logs are written to
# note: LOGS_ROOT is sourced from environment

APPNAME="CREATE EXTENDED DIRECTORIES"

# ISO 8601 variation
TIMESTAMP="$(date +%Y-%m-%d_%H:%M:%S)"

LOG_DIR="${LOGS_ROOT}/${APPNAME}-${TIMESTAMP}"

logprint() {
	mkdir -p "${LOG_DIR}"
	echo "[$(date +%Y-%m-%d_%H:%M:%S)] [${APPNAME}] $1" \
	| tee -a "${LOG_DIR}/${LOGFILE}"
}

logprint "Creating Extended Directories"

mkdir -pv ${T_SYSROOT}/{boot,home,mnt,opt,srv}
assert_zero $?

# mkdir -pv ${T_SYSROOT}
mkdir -pv ${T_SYSROOT}/lib/firmware
assert_zero $?

mkdir -pv ${T_SYSROOT}/media/{floppy,cdrom}
assert_zero $?

mkdir -pv ${T_SYSROOT}/usr/{,local/}{bin,include,lib,sbin,src}
assert_zero $?

mkdir -pv ${T_SYSROOT}/usr/{,local/}share/{color,dict,doc,info,locale,man}
assert_zero $?

mkdir -pv ${T_SYSROOT}/usr/{,local/}share/{misc,terminfo,zoneinfo}
assert_zero $?

mkdir -pv ${T_SYSROOT}/usr/{,local/}share/man/man{1..8}
assert_zero $?

mkdir -pv ${T_SYSROOT}/var/{cache,local,log,mail,opt,spool}
assert_zero $?

mkdir -pv ${T_SYSROOT}/lib/{color,misc,locate}
assert_zero $?

# ?
ln -sfv /run ${T_SYSROOT}/var/run
assert_zero $?

ln -sfv /run/lock ${T_SYSROOT}/var/lock
assert_zero $?

# create root home
install -dv -m 0750 ${T_SYSROOT}/root
assert_zero $?

# create tmp dirs
install -dv -m 1777 ${T_SYSROOT}/tmp ${T_SYSROOT}/var/tmp
assert_zero $?

# symlink /proc/self/mounts to legacy location
ln -sfv /proc/self/mounts ${T_SYSROOT}/etc/mtab
assert_zero $?

