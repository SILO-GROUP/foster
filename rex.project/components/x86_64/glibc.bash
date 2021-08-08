#!/usr/bin/env bash

# desc:
# stages, builds, installs binutils for Foster

# make variables persist in subprocesses for logging function
set -a

# register mode selections
ARGUMENT_LIST=(
    "stage"
    "build"
    "install"
    "all"
    "help"
)

# modes to associate with switches
# assumes you want nothing done unless you ask for it.
MODE_STAGE=false
MODE_BUILD=false
MODE_INSTALL=false
MODE_ALL=false
MODE_HELP=false

# the name of this application
APPNAME="glibc"
#VERSION="2.11"
VERSION="2.33"

# the file to log to
LOGFILE="${APPNAME}.script.log"

# base dir where logs will go
# HIGH_LOGS sourced from environment
LOG_BASE_PATH="${HIGH_LOGS}"

# ISO 8601 variation
TIMESTAMP="$(date +%Y-%m-%d_%H:%M:%S)"

# the path where logs are written to
LOG_DIR="${LOG_BASE_PATH}/${APPNAME}-${TIMESTAMP}"

STAGE_DIR="${BUILD_DIR}/glibc"

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
        --build)
            MODE_BUILD=true
            shift 1
            ;;
        --install)
            MODE_INSTALL=true
            shift 1
            ;;
        --all)
            MODE_ALL=true
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
	#ln -sv ld-linux.so.2 ${TARGET_SYSROOT}/lib/ld-lsb.so.3
	#ln -sv /lib/ld-linux-x86_64.so.2 ${TARGET_SYSROOT}/lib
	#ln -sv ${CX_DIR}/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
	#ln -sv ${CX_DIR}/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2


	logprint "Removing any pre-existing staging for ${APPNAME}."
	rm -Rf "${STAGE_DIR}"

	# SOURCES_DIR and BUILD_DIR are environment variables when the 
	# script is executed
	logprint "Extracting ${APPNAME} source archive to '${BUILD_DIR}'"
	tar -xvf "${SOURCES_DIR}/${APPNAME}-${VERSION}.tar.xz" -C "${BUILD_DIR}"
	assert_zero $?
	
	mv -v ${BUILD_DIR}/${APPNAME}* "${STAGE_DIR}"
	assert_zero $?

	logprint "Staging operation complete."
}

mode_build() {
	logprint "Starting build of ${APPNAME}..."
	logprint "Dumping env details to '${LOG_DIR}/${LOGFILE}.env'"
	
	env >"${LOG_DIR}/${LOGFILE}.env"
	
	logprint "Entering build dir."	
	pushd "${BUILD_DIR}"
	assert_zero $?

	logprint "Applying patches..."

	logprint "Applying FHS fix..."
	patch -p0 < "${WORKSPACE}/staging/patches/glibc-2.33-fhs-1.patch"
	assert_zero $?

	logprint "Applying BISONFLAGS fix..."
	patch -p0 < "${WORKSPACE}/staging/patches/glibc_fix_bisonflags.patch"
	assert_zero $?

	pushd "${STAGE_DIR}"
	assert_zero $?

	logprint "Making compatibility symlinks..."
	ln -sfv /lib64/ld-linux-x86-64.so.2 $LFS/lib/ld-lsb.so.3
	assert_zero $?
	
    ln -sfv /lib64/ld-linux-x86-64.so.2 $LFS/lib64
    assert_zero $?
    
    ln -sfv /lib64/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
	assert_zero $?

	logprint "Entering build subdir..."
	mkdir build
	
	pushd build
	assert_zero $?
	
	logprint "Configuring ${APPNAME}..."
	../configure \
		--prefix=/usr \
		--host=$LFS_TGT \
		--build=$(../scripts/config.guess) \
		--enable-kernel=3.2 \
		--with-headers=$LFS/usr/include \
		libc_cv_slibdir=/lib
			
	assert_zero $?
	
	logprint "Compiling..."

	MAKEFLAGS=""
	make -j1
	assert_zero $?	

	logprint "Build operation complete."
}

mode_install() {
	logprint "Starting install of ${APPNAME}..."
	
	pushd "${STAGE_DIR}/build"
	assert_zero $?
	
	make DESTDIR=${TARGET_SYSROOT} install -j1
	assert_zero $?
	
	logprint "Install operation complete."
}

mode_help() {
	echo "${APPNAME} [ --stage ] [ --build_pass1 ] [ --install_pass1 ] [ --pass1 ] [ --help ]"
	exit 0
}

# MODE_PASS1 is a meta toggle for all pass1 modes.  Modes will always 
# run in the correct order.
if [ "$MODE_ALL" = "true" ]; then
	MODE_STAGE=true
	MODE_BUILD=true
	MODE_INSTALL=true
fi

# if no options were selected, then show help and exit
if \
	[ "$MODE_HELP" != "true" ] && \
	[ "$MODE_STAGE" != "true" ] && \
	[ "$MODE_BUILD" != "true" ] && \
	[ "$MODE_INSTALL" != "true" ]
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

if [ "$MODE_BUILD" = "true" ]; then
	logprint "Build of ${APPNAME} selected."
	mode_build
	assert_zero $?
fi

if [ "$MODE_INSTALL" = "true" ]; then
	logprint "Install of ${APPNAME} selected."
	mode_install
	assert_zero $?
fi

logprint "Execution of ${APPNAME} completed."
