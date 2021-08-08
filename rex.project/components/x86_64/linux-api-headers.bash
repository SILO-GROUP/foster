#!/usr/bin/env bash

# desc:
# stages, builds, installs binutils for Foster

# make variables persist in subprocesses for logging function
set -a
VERSION="5.10.17"


# register mode selections
ARGUMENT_LIST=(
    "stage"
    "build_headers"
    "install_headers"
    "help"
)

# modes to associate with switches
# assumes you want nothing done unless you ask for it.
MODE_STAGE=false
MODE_BUILD_HEADERS=false
MODE_INSTALL_HEADERS=false
MODE_HELP=false

# the name of this application
APPNAME="linux"

# the file to log to
LOGFILE="${APPNAME}.log"

# base dir where logs will go
# HIGH_LOGS sourced from environment
LOG_BASE_PATH="${HIGH_LOGS}"

# ISO 8601 variation
TIMESTAMP="$(date +%Y-%m-%d_%H:%M:%S)"

# the path where logs are written to
LOG_DIR="${LOG_BASE_PATH}/${APPNAME}-${TIMESTAMP}"

STAGE_DIR="${BUILD_DIR}/${APPNAME}-${VERSION}"

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
        --build_headers)
            MODE_BUILD_HEADERS=true
            shift 1
            ;;
        --install_headers)
            MODE_INSTALL_HEADERS=true
            shift 1
            ;;
        --headers_all)
            MODE_HEADERS_ALL=true
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
	logprint "Starting stage of Linux for API headers..."

	logprint "Removing any pre-existing staging for Linux."
	rm -Rf "${STAGE_DIR}"

	# SOURCES_DIR and BUILD_DIR are environment variables when the 
	# script is executed
	logprint "Extracting linux source archive to '${BUILD_DIR}'"
	tar -xvf "${SOURCES_DIR}/${APPNAME}-${VERSION}.tar.xz" -C "${BUILD_DIR}"
	assert_zero $?
	
	logprint "Staging operation complete."
}

mode_build_headers() {
	logprint "Starting build of ${APPNAME} (${VERSION})..."
	
	logprint "Entering '${STAGE_DIR}'."	

	pushd "${STAGE_DIR}"
	assert_zero $?

	make mrproper
	assert_zero $?
	
	# below this line is testing
	make headers
	assert_zero $?
	
	find usr/include -name '.*' -delete
	rm usr/include/Makefile
	
	logprint "Build operation complete."
}

mode_install_headers() {
	logprint "Starting install of ${APPNAME}..."
	
	pushd "${STAGE_DIR}"
	assert_zero $?

#	make headers_install ARCH=${MARCH} INSTALL_HDR_PATH=${TARGET_SYSROOT}/usr
	cp -rv usr/include $LFS/usr
	assert_zero $?
	
	logprint "Install operation complete."
}

mode_help() {
	echo "${APPNAME} [ --stage ] [ --build_headers ] [ --install_headers ] [ --headers_all ] [ --help ]"
	exit 0
}

# MODE_PASS1 is a meta toggle for all pass1 modes.  Modes will always 
# run in the correct order.
if [ "$MODE_HEADERS_ALL" = "true" ]; then
	MODE_STAGE=true
	MODE_BUILD_HEADERS=true
	MODE_INSTALL_HEADERS=true
fi

# if no options were selected, then show help and exit
if \
	[ "$MODE_HELP" != "true" ] && \
	[ "$MODE_STAGE" != "true" ] && \
	[ "$MODE_BUILD_HEADERS" != "true" ] && \
	[ "$MODE_INSTALL_HEADERS" != "true" ]
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

if [ "$MODE_BUILD_HEADERS" = "true" ]; then
	logprint "Build of HEADERS selected."
	mode_build_headers
	assert_zero $?
fi

if [ "$MODE_INSTALL_HEADERS" = "true" ]; then
	logprint "Install of HEADERS selected."
	mode_install_headers
	assert_zero $?
fi

logprint "Execution of ${APPNAME} completed."
