#! /bin/bash

# Usage: save.sh BASE OUTPUT CONFIG

set -eu

BASE_DIR=$1
OUTPUT_DIR=$2
CODE_CONFIG=$3

while read p; do
  cp -r $BASE_DIR/$p $OUTPUT_DIR/
done < $CODE_CONFIG
