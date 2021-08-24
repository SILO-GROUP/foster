#!/bin/bash

. $1/rex.project/environments/x86_64/stage1.env.bash \
	&& $1/rex.project/components/x86_64/stage_1/prepare_vkfs.bash \
	&& $1/rex.project/components/x86_64/stage_1/enter_chroot.bash
