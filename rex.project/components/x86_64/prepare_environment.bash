#!/bin/bash
#
# Description:
# This component lays out all the directories and users and permissions
# needed to compile the rest of the project.
env
assert_zero $?

# The Application Name
APPNAME="PREPARE_HOST"

# ISO 8601 variation
TIMESTAMP="$(date +%Y-%m-%d_%H:%M:%S)"

# the path where logs are written to
# note: LOGS_ROOT is sourced from environment
LOG_DIR="${LOGS_ROOT}/${APPNAME}-${TIMESTAMP}"

# the file to log to
LOGFILE="${APPNAME}.log"

# print to stdout, print to log
logprint() {
	mkdir -p "${LOG_DIR}"
	echo "[$(date +%Y-%m-%d_%H:%M:%S)] [${APPNAME}] $1" \
	| tee -a "${LOG_DIR}/${LOGFILE}"
}

logprint "Clearing BASHRC"
# clean the environment just in case
[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE

# ----------------------------------------------------------------------
# Install Host Dependencies
# ----------------------------------------------------------------------
logprint "Installing host dependencies..."
apt-get install -y xz-utils file bison bzip2 gawk texinfo python3 rsync gettext m4
assert_zero $?

# ----------------------------------------------------------------------
# Set up binary symlinks
# ----------------------------------------------------------------------
logprint "Setting BISON->YACC symlink"
# yacc must point to bison
ln -sfv /usr/bin/bison /usr/bin/yacc
assert_zero $?

logprint "Setting AWK->GAWK symlink"
# awk must point to gawk
ln -sfv /usr/bin/gawk /usr/bin/awk 
assert_zero $?

logprint "Setting SH->BASH symlink"
# sh must point to bash
ln -sfv /bin/bash /bin/sh
assert_zero $?

# ----------------------------------------------------------------------
# Create SYSROOT directories
# ----------------------------------------------------------------------
logprint "Creating SYSROOT directories..."
# create empty dirs for the target sysroot
logprint "Generating basic top-level directories"
mkdir -pv ${T_SYSROOT}/{bin,etc,lib,sbin,usr,var} 
assert_zero $?

#logprint "Generating secondary SYSROOT directories..."
# secondaries
#mkdir -pv ${T_SYSROOT}/{boot,home,usr/src,opt,tmp}
#assert_zero $?

logprint "Generating architecture dependent lib dir..."
# target dependent
# create lib64 dir for the target sysroot
mkdir -pv ${ARCHLIB_DIR} 
assert_zero $?

logprint "Generating crosstools root dir..."
# dir for where the cross-compiler will go that builds the things inside
# the target sysroot
mkdir -pv ${CROSSTOOLS_DIR}
assert_zero $?

logprint "Creating '$TEMP_STAGE_DIR'"
mkdir -pv ${TEMP_STAGE_DIR}
assert_zero $?

# ----------------------------------------------------------------------
# Create build user/group
# ----------------------------------------------------------------------
logprint "Creating BUILD GROUP '${BUILD_GROUP}'"
getent group "${BUILD_GROUP}" \
	|| /usr/sbin/groupadd "${BUILD_GROUP}"
assert_zero $?

logprint "Creating BUILD USER '${BUILD_USER}'"
# create the user
getent passwd ${BUILD_USER} \
	|| /usr/sbin/useradd \
		-m \
		-s /bin/bash \
		-g ${BUILD_GROUP} \
		-d ${TEMP_STAGE_DIR} \
		-k /dev/null \
		${BUILD_USER}
assert_zero $?

# ----------------------------------------------------------------------
# Chown SYSROOT directories
# ----------------------------------------------------------------------
logprint "Taking ownership of '$TEMP_STAGE_DIR'"
chown -vR "${BUILD_USER}":"${BUILD_GROUP}" "${TEMP_STAGE_DIR}"
assert_zero $?

logprint "Taking ownership of '$ARCHLIB_DIR'"
chown -vR "${BUILD_USER}":"${BUILD_GROUP}" "${ARCHLIB_DIR}"
assert_zero $?

logprint "Ensuring permissions on '$SOURCES_DIR'"
# change ownership on the sources dir
chmod 777 "${SOURCES_DIR}"
assert_zero $?

logprint "Creating and owning '$LOGS_ROOT'"
mkdir -pv "${LOGS_ROOT}"
assert_zero $?
chmod -vR 777 "${LOGS_ROOT}"
assert_zero $?

logprint "Taking ownership of '$CROSSTOOLS_DIR'"
chown -vR ${BUILD_USER}:${BUILD_GROUP} ${CROSSTOOLS_DIR}
assert_zero $?

logprint "Taking ownership of ${T_SYSROOT}"
chown -v ${BUILD_USER}:${BUILD_GROUP} ${T_SYSROOT}

logprint "Taking ownership of '${T_SYSROOT}/{usr,lib,var,etc,bin,sbin}'"
chown -vR ${BUILD_USER}:${BUILD_GROUP} ${T_SYSROOT}/{usr,lib,var,etc,bin,sbin}
assert_zero $?

logprint "Taking ownership of '$ARCHLIB_DIR'"
chown -vR ${BUILD_USER}:${BUILD_GROUP} ${ARCHLIB_DIR}
assert_zero $?
