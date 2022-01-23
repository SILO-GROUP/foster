#!/bin/bash
#
# Description:
# This file is sourced by Rex prior to each task execution.
#
# We additionally source various files to keep management of these sane.

# Automatically export stuff so we don't have to do it explicitly
set -a
set +h

TERM=xterm-256color

#umask 022
#LC_ALL=POSIX

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
CONFIG_DIR=${PROJECT_ROOT}/staging/configs
SOURCES_DIR=${PROJECT_ROOT}/staging/sources
PATCHES_DIR=${PROJECT_ROOT}/staging/patches

M_SYSROOT=${PROJECT_ROOT}/staging/artifacts/T_SYSROOT

LOGS_ROOT=${PROJECT_ROOT}/staging/artifacts/logs/scripts

CROSSTOOLS_DIR=/crosstools
TEMP_STAGE_DIR=/source_stage

ARCHLIB_DIR=/lib64

T_VENDOR="darkhorse"
T_ARCH=$(uname -m)
T_TRIPLET=${T_ARCH}-${T_VENDOR}-linux-gnu

BUILD_USER="phanes"
BUILD_GROUP="royalty"

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin

CONFIG_SITE=${T_SYSROOT}/usr/share/config.site

MAKEFLAGS="-j$(nproc)"

echo "Loaded Initial Environment"
