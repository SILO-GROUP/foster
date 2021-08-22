.EXPORT_ALL_VARIABLES:

# Relative path context hack
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
workspace := $(abspath $(current_dir)/../../foster)

.DEFAULT_GOAL := all

# download the new source directory contents like LFS proper
download_sources:
	${workspace}/makefile.controls/download_sources.sh

# download the patches from LFS
# there is no clean here because i bundle fixed patches
download_patches:
	${workspace}/makefile.controls/download_patches.sh

# verify the sources downloaded are intact
verify_sources:
	${workspace}/makefile.controls/verify_sources.sh

# verify the patches downloaded are intact
verify_patches:
	${workspace}/makefile.controls/verify_patches.sh

# builds a chroot
build_stage1:
	@sudo ${workspace}/makefile.controls/build_chroot.sh

# works around apparently some kind of nesting bug w/ Rex and file descriptors
hotfix_chroot_compiler:
	@sudo ${workspace}/rex.project/components/x86_64/stage_1/libstdcxx_pass2.bash ${workspace}

# builds the rest of the system from inside the chroot
build_stage2:
	sudo ${workspace}/makefile.controls/stage_2_init.sh ${workspace}

all:
	@sudo ${workspace}/makefile.controls/build_chroot.sh && sudo ${workspace}/rex.project/components/x86_64/stage_1/libstdcxx_pass2.bash ${workspace} && sudo ${workspace}/makefile.controls/stage_2_init.sh ${workspace}

# enter the chroot after a stage1 build so we can play around 
enter_chroot:
	sudo ${workspace}/makefile.controls/enter_chroot.sh ${workspace}

# clean up artifacts between builds if desired
clean:
	${workspace}/makefile.controls/clean.sh

# wipe the source directory	
clean_sources:
	${workspace}/makefile.controls/clean_sources.sh

