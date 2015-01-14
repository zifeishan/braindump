#! /bin/bash

# The idea is to compute the expected number of correct extractions in
# each probability bucket, and use it to compute for each decision
# boundary, what's the coverage for all correct candidates. This is an
# estimation for recall, with respect to candidates.

set -e
# set -x # DEBUG

CALI_DIR=$1

mkdir -p $CALI_DIR/coverage

for f in `find $CALI_DIR/*.tsv`; do
  base=$(basename $f)
  # echo "File -> $f"
  python $UTIL_DIR/calibration/coverage-single-tsv.py $f > $CALI_DIR/coverage/$base
done