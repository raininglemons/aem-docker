#!/bin/sh
#
# NOTE: This is an adapted version of the default validate.sh script that is aware it's already in a docker
# container
#
# Script to run dispatcher validator and docker dispatcher image to test the configuration
#
# Usage: validate.sh config-folder
#
set -e

usage() {
    cat <<EOF >& 1
Usage: $0 config-folder

Example:
  # Use configuration folder "src/dispatcher", run validator and then test the configuration
  # generated by validator with httpd -t (from docker image), dump processed dispatcher.any config.
  # Finally immutability check is performed for selected config files.
  $0 src/dispatcher
EOF
    exit 1
}

# [ $# -eq 1 ] || usage

configDir=/tmp/dispatcher
scriptDir=`dirname ./dispatcher-sdk-*/bin`/bin

if [ -f "${configDir}"/opt-in/USE_SOURCES_DIRECTLY ];
then
    echo "opt-in USE_SOURCES_DIRECTLY marker file detected"

    echo "Phase 1: Dispatcher validator"
    "${scriptDir}"/validator full -relaxed "${configDir}"
    echo "Phase 1 finished"

    echo "Phase 2: httpd -t validation in docker image"
    /usr/sbin/httpd-test
    echo "Phase 2 finished"

    echo "Phase 3: Immutability check"
    "${scriptDir}"/immutability_check.sh /etc/httpd/immutable.files.txt "${configDir}" check
    echo "Phase 3 finished"
else
    timestamp=$(date +%s)
    tempDir="/tmp/dispatcher_validation_${timestamp}"

    rm -rf "${tempDir}"
    mkdir -p "${tempDir}"

    echo "Phase 1: Dispatcher validator"
    "${scriptDir}"/validator full -d "${tempDir}" "${configDir}"
    echo "Phase 1 finished"

    echo "Phase 2: httpd -t validation in docker image"
    /usr/sbin/httpd-test
    echo "Phase 2 finished"

    echo "Phase 3: Immutability check"
    "${scriptDir}"/immutability_check.sh /etc/httpd/immutable.files.txt "${configDir}" check
    echo "Phase 3 finished"

    rm -rf "${tempDir}"
fi
