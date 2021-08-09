#!/bin/bash

# downloads sources for various packages necessary 

wget \
	-q \
	--show-progress \
	--input-file=${workspace}/staging/patches/10.1_patches.txt \
	--continue \
	--directory-prefix=${workspace}/staging/patches

