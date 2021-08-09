#!/bin/bash
#
#    Foster - Installer ISO for SURRO Linux.
#
#    © SURRO INDUSTRIES and Chris Punches, 2017.
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Description:
# This file is sourced by Examplar prior to each task execution.
#
# We additionally source various files to keep management of these sane.

# Automatically export stuff so we don't have to do it explicitly
set -a

# disable caching of paths in which executables are located when they
# are called
set +h

umask 022

# Set a basic terminal
TERM=xterm-256color

# override LC_ALL for each build
LC_ALL=POSIX
#LC_ALL=C

# where this project is cloned to
WORKSPACE=/opt/foster

HIGH_LOGS="${WORKSPACE}/logs/scripts/"

# A mutable directory in the shared volume so that inspection can occur
# between builds.
OUTDIR=/home/bagira/ALFS_OUTPUT

## the SYSROOT directory that will eventually be the chroot
TARGET_SYSROOT=${OUTDIR}/SYSROOT

ARCHLIB_DIR=${TARGET_SYSROOT}/lib64

# cross build tools used to build the build tools in X_DIR
CX_DIR=/${TARGET_SYSROOT}/cross-compiler

# native build tools used to populate FOSTER_ROOT
X_DIR=/${TARGET_SYSROOT}/target-compiler

# the directory where staged files go.  these are user supplied.
EXT_STAGING_DIR=${WORKSPACE}/staging

# sources
# storage directory for source code for everything as its being built
SOURCES_DIR=${EXT_STAGING_DIR}/source

# where the sources are built
BUILD_DIR=${OUTDIR}/temporary_build_directory

# patches
# storage directory for patches
PATCH_DIR=${EXT_STAGING_DIR}/patches

# the home directory of our non-root build user
# needs to match BUILD_DIR, this is an environment var that the
# shell will look for
HOME=${BUILD_DIR}

# builder user and group settings
BUILD_GROUP=royalty
BUILD_USER=phanes

# fail the unit in the event of a non-zero value passed
# used primarily to check exit codes on previous commands
assert_zero() {
	if [[ "$1" -eq 0 ]]; then 
		return
	else
		exit $1
	fi
}

# configure script hack
CONFIG_SITE=${TARGET_SYSROOT}/usr/share/config.site

# makeflags
MAKEFLAGS='-j22'


TARCH=x86_64
VENDOR=lfs
TARGET_ARCH=${TARCH}-${VENDOR}-linux-gnu

# questionable LFS hack
CONFIG_SITE=${TARGET_SYSROOT}/usr/share/config.site

# path
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$CX_DIR/bin:$PATH

PS1="\n[ \u @ \H ] << \w >>\n\n[- "

# Compatibility
LFS=${TARGET_SYSROOT}
LFS_TGT=${TARGET_ARCH}


echo "Loaded Initial Environment"
