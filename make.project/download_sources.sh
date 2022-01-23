#!/bin/bash

# downloads sources for various packages necessary 
wget \
	-q \
	--show-progress \
	--input-file=${config_dir}/sources/10.1_sources.txt \
	--continue \
	--directory-prefix=${sources_dir}

echo "Download returned with exit code '$?'."
