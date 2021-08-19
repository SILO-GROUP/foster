.DEFAULT_GOAL := build

.EXPORT_ALL_VARIABLES:

# Relative path context hack
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
workspace := $(abspath $(current_dir)/../../foster)

build:
	@sudo ${workspace}/build_chroot.sh

build_chroot:
	@sudo ${workspace}/build_chroot.sh

# clean up artifacts between builds if desired
# includes logs
clean:
	@${workspace}/makefile.controls/clean.sh

# wipe the source directory	
clean_sources:
	@${workspace}/makefile.controls/clean_sources.sh

# download the new source directory contents from LFS proper
download_sources:
	${workspace}/makefile.controls/download_sources.sh

# download the patches from LFS
# there is no clean here because i bundle fixed patches
download_patches:
	@${workspace}/makefile.controls/download_patches.sh

# verify the sources downloaded are intact
verify_sources:
	@${workspace}/makefile.controls/verify_sources.sh

# verify the patches downloaded are intact
verify_patches:
	@${workspace}/makefile.controls/verify_patches.sh

enter_chroot:
	@${workspace}/makefile.controls/enter_chroot.sh
