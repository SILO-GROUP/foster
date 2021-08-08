#!/bin/bash

# desc:
# stages, builds, installs binutils for Foster

# make variables persist in subprocesses for logging function
set -a

#APP_VERSION="2.25"
APP_VERSION="2.36.1"

# register mode selections
ARGUMENT_LIST=(
    "stage"
    "build_pass1"
    "install_pass1"
    "pass1"
    "help"
)

# modes to associate with switches
# assumes you want nothing done unless you ask for it.
MODE_STAGE=false
MODE_BUILD_PASS1=false
MODE_INSTALL_PASS1=false
MODE_PASS1=false
MODE_HELP=false

# the name of this application
APPNAME="$(basename "$0")"

# the file to log to
LOGFILE="${APPNAME}.log"

# base dir where logs will go
# HIGH_LOGS sourced from environment
LOG_BASE_PATH="${HIGH_LOGS}"

# ISO 8601 variation
TIMESTAMP="$(date +%Y-%m-%d_%H:%M:%S)"

# the path where logs are written to
LOG_DIR="${LOG_BASE_PATH}/${APPNAME}-${TIMESTAMP}"

STAGE_DIR="${BUILD_DIR}/binutils"

# read defined arguments
opts=$(getopt \
    --longoptions "$(printf "%s," "${ARGUMENT_LIST[@]}")" \
    --name "$APPNAME" \
    --options "" \
    -- "$@"
)

# process supplied arguments into flags that enable execution modes
eval set --$opts
while [[ $# -gt 0 ]]; do
    case "$1" in
        --stage)
            MODE_STAGE=true
            shift 1
            ;;
        --build_pass1)
            MODE_BUILD_PASS1=true
            shift 1
            ;;
        --install_pass1)
            MODE_INSTALL_PASS1=true
            shift 1
            ;;
        --pass1)
            MODE_PASS1=true
            shift 1
            ;;
        --help)
            MODE_HELP=true
            shift 1
            ;;
        *)
            break
            ;;
    esac
done

# print to stdout, print to log
logprint() {
	mkdir -p "${LOG_DIR}"
	echo "[$(date +%Y-%m-%d_%H:%M:%S)] [${APPNAME}] $1" \
	| tee -a "${LOG_DIR}/${LOGFILE}"
}

# Tell the user we're alive...
logprint "Initializing the ${APPNAME} utility..."

# assert a value is zero or exit the script
assert_zero() {
	if [[ "$1" -eq 0 ]]; then
		return
	else
		logprint "Assertion Zero failed. Exited with a value of '$1'."
		exit 1
	fi
}

mode_stage() {
	logprint "Starting stage of ${APPNAME}..."

	logprint "Removing any pre-existing staging for ${APPNAME}."
	rm -Rf "${BUILD_DIR}/binutils*"

	# SOURCES_DIR and BUILD_DIR are environment variables when the 
	# script is executed
	logprint "source archive: ${SOURCES_DIR}/binutils-2.36.1.tar.xz"
	logprint "BUILD_DIR: ${BUILD_DIR}"
	
	tar xvf "${SOURCES_DIR}/binutils-${APP_VERSION}.tar."* -C "${BUILD_DIR}"
	assert_zero $?

	# conditionally rename if it needs it
	stat ${BUILD_DIR}/binutils-* && mv ${BUILD_DIR}/binutils-* ${BUILD_DIR}/binutils

	logprint "Staging operation complete."
}

mode_build_pass1() {
	logprint "Starting build of ${APPNAME}..."
	
	logprint "Entering build dir."	
	pushd "${STAGE_DIR}"
	assert_zero $?



	mkdir -p build
	pushd build
	assert_zero $?
	
	logprint "Configuring binutils..."
	../configure \
		--prefix=$CX_DIR \
		--with-sysroot=$LFS \
		--target=$LFS_TGT \
		--disable-nls \
		--disable-werror
		
	assert_zero $?
	
	logprint "Compiling..."

	make -j1
	assert_zero $?	

	logprint "Build operation complete."
}

mode_install_pass1() {
	logprint "Starting install of ${APPNAME}..."
	pushd "${STAGE_DIR}/build"
	assert_zero $?
	
	make install -j1
	assert_zero $?
	
	logprint "Install operation complete."
}

mode_help() {
	echo "${APPNAME} [ --stage ] [ --build_pass1 ] [ --install_pass1 ] [ --pass1 ] [ --help ]"
	exit 0
}

# MODE_PASS1 is a meta toggle for all pass1 modes.  Modes will always 
# run in the correct order.
if [ "$MODE_PASS1" = "true" ]; then
	MODE_STAGE=true
	MODE_BUILD_PASS1=true
	MODE_INSTALL_PASS1=true
fi

# if no options were selected, then show help and exit
if \
	[ "$MODE_HELP" != "true" ] && \
	[ "$MODE_STAGE" != "true" ] && \
	[ "$MODE_BUILD_PASS1" != "true" ] && \
	[ "$MODE_INSTALL_PASS1" != "true" ]
then
	logprint "No option selected during execution."
	mode_help
fi

# if help was supplied at all, show help and exit
if [ "$MODE_HELP" = "true" ]; then
	logprint "Help option selected.  Printing options and exiting."
	mode_help
fi

if [ "$MODE_STAGE" = "true" ]; then
	logprint "Staging option selected."
	mode_stage
	assert_zero $?
fi

if [ "$MODE_BUILD_PASS1" = "true" ]; then
	logprint "Build of PASS1 selected."
	mode_build_pass1
	assert_zero $?
fi

if [ "$MODE_INSTALL_PASS1" = "true" ]; then
	logprint "Install of PASS1 selected."
	mode_install_pass1
	assert_zero $?
fi

logprint "Execution of ${APPNAME} completed."
