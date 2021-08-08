# use the latest version of fedora for the build system
#FROM debian:stable
FROM ubuntu:latest

# Environment Variables
ENV TERM xterm
ENV container docker

# workaround: some kind of signal relay issue
STOPSIGNAL SIGRTMIN+3

# Update all packages, install git/cmake/dev tools
RUN DEBIAN_FRONTEND="noninteractive" apt-get autoclean && apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install git g++ make cmake 
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install whiptail

# for initial builds
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install xz-utils file bison bzip2 gawk texinfo python3 rsync gettext

# rex source acquisition

# This directory will be replaced by the workspace in the volume
WORKDIR "/opt"

# Pull down rex
RUN git clone https://source.silogroup.org/Cycle0/Rex.git rex

# Change dir to rex
WORKDIR "/opt/rex"

# Build and install rex
RUN cmake . && \
	make && \
	cp rex /usr/bin/rex

# Development Pull from Local
WORKDIR "/opt/foster"

# benign entry point
ENTRYPOINT [ "bash" ]
