#!/bin/bash

# copy the target profile to ./.config so the build process knows
# what it's building
cp -vf "${SOURCES}/${TARGET_PROFILE}.ctng.config" "${CTNG_BUILD_DIR}/.config"
assert_zero $?

chown -vR "${BUILD_USER}":"${BUILD_GROUP}" /opt/ctng
assert_zero $?

