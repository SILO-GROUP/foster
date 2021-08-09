#!/bin/bash

# downloads sources for various packages necessary 

wget \
	-q \
	--show-progress \
	--input-file=${workspace}/staging/source/10.1_sources.txt \
	--continue \
	--directory-prefix=${workspace}/staging/source

