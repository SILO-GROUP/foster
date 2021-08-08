.DEFAULT_GOAL := build
.EXPORT_ALL_VARIABLES:

# Relative path context hack
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
workspace := $(abspath $(current_dir)/../../workspace)

build:
	${workspace}/makefile.controls/init.sh

clean:
	${workspace}/makefile.controls/clean.sh
	
clean_sources:
	${workspace}/makefile.controls/clean_sources.sh

download_sources:
	${workspace}/makefile.controls/download_sources.sh
