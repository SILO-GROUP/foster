#!/bin/bash

. $1/rex.project/environments/x86_64/initial_environment.bash \
	&& $1/rex.project/components/x86_64/enter_chroot.bash
