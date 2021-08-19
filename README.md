# ALFS-NG
An experimental fork of the SURRO/Foster project to examine using the
Rex utility to automate parts of the LFS toolchain generation.  

# Requirements
Make, g++, and Rex ( installed at `/usr/local/bin/rex` ).

Tested on Ubuntu 20.04

Rex source: https://github.com/SILO-GROUP/Rex

Assumes you cloned the project to `/opt/foster`

# makefile Driven
this project is makefile driven

## make build_chroot
kick off the rex project

## make clean
clean the logs between builds and/or commits

## make clean_sources
clean the sources dir.

## make download_sources
download the sources

## make download_patches
download the patches

## make verify_sources
verify the sources' checksums for file integrity verification

## make verify_patches
verify the patches' file integrity

## make enter_chroot
This will allow you to enter the chroot you created with the `make build_chroot` command.
