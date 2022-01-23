#!/bin/bash

cat << EOF
	make clean
	make download_rex
	make compile_rex
	make download_sources
	make verify_sources
	make download_patches
	make verify patches
	make build_stage1
	make hotfix_chroot_compiler
	make build_stage2
	make distclean
EOF
