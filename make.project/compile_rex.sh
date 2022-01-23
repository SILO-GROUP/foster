#!/bin/bash

pushd ${artifacts_dir}/rex || exit 1
cmake .
make
