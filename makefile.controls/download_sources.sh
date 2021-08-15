#!/bin/bash

# downloads sources for various packages necessary 

wget \
	-q \
	--show-progress \
	--input-file=${workspace}/staging/sources/10.1_sources.txt \
	--continue \
	--directory-prefix=${workspace}/staging/sources

