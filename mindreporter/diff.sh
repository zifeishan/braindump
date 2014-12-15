#! /bin/bash

# Usage: save.sh BASE OUTPUT CONFIG

set -eu
set -x
OLD_DIR=$1
NEW_DIR=$2
OUTPUT_FILE=$3

diff -ENwbur $OLD_DIR $NEW_DIR > $OUTPUT_FILE | true
