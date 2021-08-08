###################
# Terminology
###################
#
# So, while they appear to have similar functions, a sysroot deals with
# linked header files and sources, and a prefix deals with artifacts of
# your build.
set -a
source environments/common-users.bash

# Workspace
#
# The project workspace - used as an anchor to refer to the project 
# files on the local filesystem as well as serving as the mountpoint
# for the workspace in the container; allows us to run scripts that 
# depend on the WORKSPACE context in both locations despite it 
# technically being in both places.
WORKSPACE="/opt/foster"

## Sysroot
#
# A sysroot is a directory which is considered to be the root directory 
# for the purpose of locating headers and libraries. So for example if 
# your build toolchain wants to find /usr/include/foo.h but you are 
# cross-compiling and the appropriate foo.h is in
# /my/other/place/usr/include/foo.h, you would use /my/other/place as 
# your sysroot.
SYSROOT="${WORKSPACE}/sysroot"

# SOURCES
#
# The directory where source code is stored. See `make download_sources`
# for how to populate this directory with everything you'll need.
SOURCES="${WORKSPACE}/sources"

# BUILD_DIR
#
# The parent directory where source will be staged to for compilation.
BUILD_DIR="/usr/src"

# CTNG_PREFIX
# ## --prefix
# When you install software with make install or sudo make install, 
# different files are placed in different directories. Executables that
# provide commands the user is intended to run usually go in a bin
# directory, libraries usually go in a lib directory, manual pages 
# usually go in a man directory, and so forth.
#
# When you run ./configure, the --prefix option lets you specify where 
# those directories are. It is called --prefix because it lets you give 
# the prefix that appears in the paths to each of the directories where
# files from the program or library that you are building are to be 
# installed. Most configure scripts support --prefix, and omitting it 
# and just running ./configure is typically equivalent to ./configure
# --prefix=/usr/local.
CTNG_PREFIX=/opt/ctng
 
# CTNG_BIN
#
# The directory where CTNG will dump its own executables when it itself
# is compiled.
CTNG_BIN="${CTNG_PREFIX}/bin"

# CTNG_PATH
# 
# Adds CTNG_BIN to PATH 
PATH=${PATH}:${CTNG_BIN}

# toolchain prefix
CTNG_TC_PREFIX="${CTNG_PREFIX}/toolchain"

# home dir for user
# for some retarded reason ctng tries to use all sorts of directories
# you didn't tell it to use
HOME="/home/${BUILD_USER}"

# Where CTNG stages tarballs it downloads, whether you tell it somewhere else or not.
CTNG_TAR_STAGING="${HOME}/src"

# where the CTNG source is staged to
CTNG_SRC_DIR="${BUILD_DIR}/crosstool-ng"

# where the configs are.. dedicated build dir for ctng
CTNG_BUILD_DIR="${CTNG_SRC_DIR}/build"
