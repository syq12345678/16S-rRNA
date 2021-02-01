#!/usr/bin/env bash

usage () { echo "bash uzcat.sh <stats.qzv> [feature-frequency-detail.csv]" 1>&2; exit; }
[ $# -lt 1 ] && usage

ZIP_FILE=$1
PATTERN=${2:-feature-frequency-detail.csv}

if [ ! -e ${ZIP_FILE} ]; then
    echo 1>&2 "[${ZIP_FILE}] is not a file" 1>&2; exit;
fi

MATCHED=$(unzip -Z1 ${ZIP_FILE} | grep -w "${PATTERN}" | head -n 1)

if [ "${MATCHED}" == "" ]; then
    echo 1>&2 "[${PATTERN}] can't be found" 1>&2; exit;
fi

unzip -p ${ZIP_FILE} ${MATCHED}
