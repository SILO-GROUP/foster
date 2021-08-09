# Source Staging Directory

This directory is where sources can be staged.

If you want to rely on the default LFS locations, simply
run `make download` in the project workspace.

To clean this directory of all source archives, run:

`make clean_sources`

Since LFS doesn't ever seem to work out of the box for some reason, what
I do is download several versions of, for instance gcc, binutils, glibc
until I find a working combination.
