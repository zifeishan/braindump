#! /bin/bash

# Usage: save.sh BASE OUTPUT CONFIG

set -eu

OLD_DIR=$1
NEW_DIR=$2

diff -ENwbur $OLD_DIR $NEW_DIR