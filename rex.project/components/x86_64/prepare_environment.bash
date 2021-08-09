#!/bin/bash
#
#    Foster - Installer ISO for SURRO Linux.
#
#    © SURRO INDUSTRIES and Chris Punches, 2017.
#
#    This program is free software: you can redistribute it and/or 
#    modify it under the terms of the GNU Affero General Public License
#    as published by the Free Software Foundation, either version 3 of 
#    the License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public 
#    License along with this program.  If not, see 
#    <https://www.gnu.org/licenses/>.
#
# Description:
# This component lays out all the directories and users and permissions
# needed to compile the rest of the project.

# - creates empty sysroot
# - creates crosstools dir
# - creates source build dir
# - creates build group
# - creates build user
# - sets ownership of build dir to build user

# clean the environment just in case
[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE

mkdir -p ${BUILD_DIR}
assert_zero $?

# create the user's group
getent group "${BUILD_GROUP}" \
	|| groupadd "${BUILD_GROUP}"
assert_zero $?

# create the user
getent passwd "${BUILD_USER}" \
	|| useradd \
		-m \
		-s /bin/bash \
		-g "${BUILD_GROUP}" \
		-d "${BUILD_DIR}" \
		-k /dev/null \
		"${BUILD_USER}"
assert_zero $?

# create empty dirs for the target sysroot
mkdir -p ${TARGET_SYSROOT}/{bin,etc,lib,sbin,usr,var} 
assert_zero $?

# secondaries
mkdir -p ${TARGET_SYSROOT}/{boot,home,usr/src,opt,tmp}
assert_zero $?

# target dependent
# create lib64 dir for the target sysroot
mkdir -p ${ARCHLIB_DIR} 
assert_zero $?

# dir for where the cross-compiler will go that builds the things inside
# the target sysroot
mkdir -p ${CX_DIR}
assert_zero $?



# change ownership on the build_dir
chown -vR "${BUILD_USER}":"${BUILD_GROUP}" "${BUILD_DIR}"
assert_zero $?

# change ownership on the sysroot's arch dependent lib dir
chown -vR "${BUILD_USER}":"${BUILD_GROUP}" "${ARCHLIB_DIR}"
assert_zero $?

# change ownership on the sources dir
chmod 777 "${SOURCES_DIR}"
#assert_zero $?

mkdir -p "${HIGH_LOGS}"
chmod -vR 777 "${HIGH_LOGS}"

chown -vR "${BUILD_USER}":"${BUILD_GROUP}" "${CX_DIR}"

chown -vR "${BUILD_USER}":"${BUILD_GROUP}" ${TARGET_SYSROOT}/{usr,lib,var,etc,bin,sbin}
chown -vR "${BUILD_USER}":"${BUILD_GROUP}" ${ARCHLIB_DIR}

umask 022

ln -sfv /usr/bin/bison /usr/bin/yacc
ln -sfv /usr/bin/gawk /usr/bin/awk 
ln -sfv /bin/bash /bin/sh
