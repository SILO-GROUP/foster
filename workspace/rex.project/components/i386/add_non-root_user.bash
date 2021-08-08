#!/bin/bash

# create the user's group
getent group "${BUILD_GROUP}" || groupadd "${BUILD_GROUP}"
assert_zero $?

# create the user
getent passwd "${BUILD_USER}" || useradd -s /bin/bash -g "${BUILD_GROUP}" -d "${HOME}" "${BUILD_USER}"
assert_zero $?

# TODO: move to own step
# own the dir to prevent weird perms issues -- this not a normal system
# user so the rules are a little different
chown -vR "${BUILD_USER}":"${BUILD_GROUP}" "${BUILD_DIR}"
assert_zero $?
