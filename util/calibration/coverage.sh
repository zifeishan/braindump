#! /bin/bash

# The idea is to compute the expected number of correct extractions in
# each probability bucket, and use it to compute for each decision
# boundary, what's the coverage for all correct candidates. This is an
# estimation for recall, with respect to candidates.

set -e
# set -x # DEBUG

OUTPUT_DIR=$1
table_name=$2
column_name=$3

psql $DBNAME -c " COPY (
  SELECT bucket, sum(expectation)
  FROM ${table_name}_${column_name}_inference_bucketed
  GROUP BY bucket
  ORDER BY bucket
) TO STDOUT
" > $OUTPUT_DIR/${table_name}.${column_name}.details.tsv

python $UTIL_DIR/calibration/coverage-single-tsv.py \
  $OUTPUT_DIR/${table_name}.${column_name}.details.tsv \
  > $OUTPUT_DIR/${table_name}.${column_name}.tsv
