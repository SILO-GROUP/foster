#!/bin/bash

. ${rex_dir}/environments/stage1.env.bash \
	&& ${rex_dir}/components/x86_64/stage_1/prepare_vkfs.bash \
	&& ${rex_dir}/components/x86_64/stage_1/enter_chroot.bash
