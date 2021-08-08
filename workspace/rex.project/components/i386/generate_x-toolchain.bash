#!/bin/bash


#ct-ng menuconfig
#assert_zero $?
mkdir -p "${CTNG_TAR_STAGING}"
assert_zero $?

# the build dir where the configs are
pushd "${CTNG_BUILD_DIR}"

# build the toolchain
ct-ng build
assert_zero $?

dirs -c
