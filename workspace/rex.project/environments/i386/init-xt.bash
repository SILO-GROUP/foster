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

# the directory that is the shared volume with the host
WORKSPACE=/opt/foster

# A mutable directory in the shared volume so that inspection can occur
# between builds.
OUTDIR=/opt/foster/output

## the SYSROOT directory that will eventually be the chroot
FOSTER_ROOT=${OUTDIR}/foster_sysroot

# cross build tools used to build the build tools in X_DIR
CX_DIR=/opt/cross-compiler

# native build tools used to populate FOSTER_ROOT
X_DIR=/opt/target-compiler

# CTNG dir
CTNG_DIR=${OUTDIR}/ctng

# sources
# storage directory for source code for everything as its being built
SOURCES_DIR=${WORKSPACE}/sources
BUILD_DIR=${OUTDIR}/build
HOME=${BUILD_DIR}

# patches
# storage directory for patches
PATCH_DIR=${WORKSPACE}/patches

# override LC_ALL for each build
LC_ALL=C

# Fix path to look at the CTNG dir first
# crosstools dir second
# local last
PATH=${CTNG_DIR}/bin:${CX_DIR}/bin:/bin:/usr/bin:/usr/sbin

## mark for deletion?
# clean the environment
#unset CFLAGS CXXFLAGS PKG_CONFIG_PATH

# Set a basic terminal
TERM=xterm-256color

# builder user and group settings
BUILD_GROUP=royalty
BUILD_USER=phanes

assert_err() {
	if [[ "$1" -eq 0 ]]; then 
		return
	else
		exit $1
	fi
}

apply_patches() {
# apply_patches $PATCH_DIR $TARGET_DIR
	# TODO add check if $1 is supplied
	patch_dir="$1"
	target_dir="$2"

	pushd ${target_dir} 2>&1 >/dev/null
	
	# this is hacky, fix whitespace issues please
	for patch in $(find ${patch_dir} -type f -name '*.patch' | sort -z); do
		patch -p1 < $patch;
		assert_err $?
	done
	
	popd 2>&1 >/dev/null
}

LOG_DIR=${OUTDIR}/Logs


