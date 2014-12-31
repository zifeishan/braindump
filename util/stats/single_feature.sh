#! /bin/bash

# Usage: stats.sh BASE OUTPUT CONFIG

set -e
# set -x # DEBUG

OUTPUT_DIR=$1
TABLE=$2
FEATURE_COLUMN=$3

set -u

touch $OUTPUT_DIR/$TABLE.txt

printf "* Total number of features: %d\n" `psql $DBNAME -c " COPY (
  SELECT COUNT(*)
  FROM ${TABLE} ) TO STDOUT
  "` >> $OUTPUT_DIR/$TABLE.txt

printf "* Number of distinct features: %d\n" `psql $DBNAME -c " COPY (
  SELECT COUNT(DISTINCT $FEATURE_COLUMN)
  FROM ${TABLE} ) TO STDOUT
  "` >> $OUTPUT_DIR/$TABLE.txt


printf "* Good-Turing estimation of prob. that next extracted feature is new:\n" >> $OUTPUT_DIR/$TABLE.txt

# Good-turing estimator
$UTIL_DIR/stats/good_turing_estimator.sh $TABLE $FEATURE_COLUMN $OUTPUT_DIR/$TABLE.txt

