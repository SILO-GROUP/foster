#!/bin/bash

# install dependencies
apt-get -y install \
flex \
texinfo \
bzip2 \
xz-utils \
unzip \
help2man \
file \
gawk \
libtool-bin \
libncurses-dev \
bison \
gcc \
g++ \
gperf \
bison \
flex \
texinfo \
help2man \
make \
libncurses5-dev \
python3-dev \
autoconf \
automake \
libtool \
libtool-bin \
gawk \
wget \
bzip2 \
xz-utils \
unzip \
patch \
libstdc++6 \
rsync

assert_zero $?

# crosstool-ng version that is expected
# this should allow us to rely on naming conventions for future ctng
# releases
CTNG_VER="1.24.0"

mkdir -p "${CTNG_TAR_STAGING}"
assert_zero $?


# create the dir name in the sources dir
ctng_dir_name="crosstool-ng-${CTNG_VER}"

# copy the CTNG source dir to the staging dir to be built
cp -Rfv "${SOURCES}/${ctng_dir_name}" "${CTNG_SRC_DIR}"

# ensure the last command ran successfully
assert_zero $?

# enter the newly staged dir
pushd "${CTNG_SRC_DIR}"
assert_zero $?

# create a build dir
mkdir "${CTNG_BUILD_DIR}"
pushd "${CTNG_BUILD_DIR}"

# run the configure script
../configure --prefix="${CTNG_PREFIX}"
assert_zero $?

# compile
make
assert_zero $?

# install
make install
assert_zero $?

dirs -c
