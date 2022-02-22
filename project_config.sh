#!/bin/bash 

# project_config
# -
# This file sets some globals for the make project as well as for the 
# rest of the build process components.  It is assumed to be in the root
# of the project directory.

# set all vars to export automatically
set -a

#
## Shared Variables
#

# this is where the directory for foster is located. serves as the 
# parent directory for most other directories
project_root="$(dirname $(readlink -f "${BASH_SOURCE[0]}"))"

# the project files for the make system that is used to orchestrate the 
# build steps
make_dir=${project_root}/make.project

# the stage directory.  this contains the mutable directory where 
# artifacts are created, as well as the directories which store
# configuration for cacheable items (like source code packages, patches,
# et al.)
stage_dir=${project_root}/stage

# the mutable directory.  Anything created by the build process should
# go here to prevent a myriad of issues.
artifacts_dir=${stage_dir}/artifacts

# path for the logs
logs_dir=${artifacts_dir}/logs

# config directory - general path for configuration files on the target
# system before they're placed, as well as various values for configure
# of the build
config_dir=${stage_dir}/configs

# the patches directory.  this contains all the patches we use during
# the foster build
patches_dir=${stage_dir}/patches

# sources dir.  this path is the directory for where the sources go that
# get compiled for the initial chroot/sysroot
sources_dir=${stage_dir}/sources

# the rex project directory contains all the componennts used by the rex
# utility when it takes over compilation
rex_dir=${project_root}/rex.project

# The target SYSROOT being compiled
T_SYSROOT=${artifacts_dir}/T_SYSROOT

# where the units for this rex project are located
units_dir=${rex_dir}/units/x86_64/

# build user
build_user="phanes"

# build group
build_group="royalty"

# vendor prefix in CX compiler
CX_VENDOR_PREFIX="dhl"

#
## End of Shared Variables
#

# if we're being supplied parameters we assume it's being called by make
# and need to recall make with all appropriate vars set
if [ -n "$1" ]; then
    # The first argument is set, call back into make.
    $1 $2
fi

# EOF
