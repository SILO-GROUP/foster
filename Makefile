.DEFAULT_GOAL := build
.EXPORT_ALL_VARIABLES:

# Relative path context hack
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
workspace := $(abspath $(current_dir)/../../foster)

build:
	${workspace}/makefile.controls/init.sh

clean:
	${workspace}/makefile.controls/clean.sh
	
clean_sources:
	${workspace}/makefile.controls/clean_sources.sh

download_sources:
	${workspace}/makefile.controls/download_sources.sh

download_patches:
	${workspace}/makefile.controls/download_patches.sh

verify_sources:
	${workspace}/makefile.controls/verify_sources.sh

verify_patches:
	${workspace}/makefile.controls/verify_patches.sh

