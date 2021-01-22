#!/usr/bin/env bash

usage () { echo "bash uzcat.sh <taxonomy.qzv> [metadata.tsv]" 1>&2; exit; }
[ $# -lt 1 ] && usage

ZIP_FILE=$1
PATTERN=${2:-metadata.tsv}

if [ ! -e ${ZIP_FILE} ]; then
    echo 1>&2 "[${ZIP_FILE}] is not a file" 1>&2; exit;
fi

MATCHED=$(unzip -Z1 ${ZIP_FILE} | grep -w "${PATTERN}" | head -n 1)

if [ "${MATCHED}" == "" ]; then
    echo 1>&2 "[${PATTERN}] can't be found" 1>&2; exit;
fi

unzip -p ${ZIP_FILE} ${MATCHED}
