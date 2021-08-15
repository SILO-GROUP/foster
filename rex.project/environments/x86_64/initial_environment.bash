#!/bin/bash
#
# Description:
# This file is sourced by Examplar prior to each task execution.
#
# We additionally source various files to keep management of these sane.

# Automatically export stuff so we don't have to do it explicitly
set -a
set +h
umask 022
LC_ALL=POSIX

# fail the unit in the event of a non-zero value passed
# used primarily to check exit codes on previous commands
# also a great convenient place to add in a "press any key to continue"
assert_zero() {
	if [[ "$1" -eq 0 ]]; then 
		return
	else
		exit $1
	fi
}

PROJECT_ROOT=/opt/foster

SOURCES_DIR=${PROJECT_ROOT}/staging/sources
PATCHES_DIR=${PROJECT_ROOT}/staging/patches

T_SYSROOT=${PROJECT_ROOT}/T_SYSROOT
LOGS_ROOT=${PROJECT_ROOT}/logs/scripts

CROSSTOOLS_DIR=${T_SYSROOT}/crosstools
TEMP_STAGE_DIR=${T_SYSROOT}/source_stage
ARCHLIB_DIR=${T_SYSROOT}/lib64

T_VENDOR="rhl"
T_TRIPLET=$(uname -m)-${T_VENDOR}-linux-gnu

BUILD_USER="phanes"
BUILD_GROUP="royalty"

PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=${CROSSTOOLS_DIR}/bin:$PATH

# Compatibility
LFS=${T_SYSROOT}
LFS_TGT=${T_TRIPLET}
CONFIG_SITE=$LFS/usr/share/config.site

MAKEFLAGS="-j$(nproc)"

echo "Loaded Initial Environment"
