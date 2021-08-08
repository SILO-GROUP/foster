# Cross-compiler generation environment file.

# This environment should be considered an extension of crosstool-ng_gen_0
source environments/crosstool-ng_gen_0.bash

# Introducing the requirement to create a non-root user
source environments/common-users.bash

# the profile for target architecture, used to reference the right
# config file
TARGET_PROFILE="x86_64-unknown-linux-gnu"


