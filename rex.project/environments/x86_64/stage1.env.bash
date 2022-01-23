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

PROJECT_ROOT=${project_root}
CONFIG_DIR=${config_dir}
SOURCES_DIR=${sources_dir}
PATCHES_DIR=${patches_dir}

#T_SYSROOT=${T_SYSROOT}
LOGS_ROOT=${logs_dir}/rex-output

CROSSTOOLS_DIR=${T_SYSROOT}/crosstools
TEMP_STAGE_DIR=${T_SYSROOT}/source_stage

ARCHLIB_DIR=${T_SYSROOT}/lib64

T_VENDOR="rhl"
T_ARCH=$(uname -m)
T_TRIPLET=${T_ARCH}-${T_VENDOR}-linux-gnu

BUILD_USER="phanes"
BUILD_GROUP="royalty"

PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=${CROSSTOOLS_DIR}/bin:$PATH:/usr/sbin:/usr/local/bin

CONFIG_SITE=${T_SYSROOT}/usr/share/config.site

MAKEFLAGS="-j$(nproc)"

echo "Loaded Initial Environment"
