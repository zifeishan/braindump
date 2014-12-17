#! /bin/bash

# Usage: save.sh BASE OUTPUT CONFIG

set -eu

# set -x # DEBUG

BASE_DIR=$1
OUTPUT_DIR=$2
# TODO if defined "CODE_CONFIG (array), use that. Otherwise use default"
CODE_CONFIG=${CODE_CONFIG:-"$UTIL_DIR/code_default.conf"}

while read p; do
  cp -r $BASE_DIR/$p $OUTPUT_DIR/
done < $CODE_CONFIG
