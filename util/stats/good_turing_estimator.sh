#! /bin/bash

# set -x # DEBUG

TABLE_NAME=$1
COLUMN_NAME=$2
OUTPUT_FILE=$3
# Use WHERE clause to filter all mentions if presents.
WHERE_CLAUSE=${4:-}

num_samples=`psql $DBNAME -c " COPY (
  SELECT count(*) AS N
     FROM $TABLE_NAME
     $WHERE_CLAUSE
) TO STDOUT"`

turing_estimator=`psql $DBNAME -c " COPY (
SELECT count(*)::float /
  (SELECT count(*) AS N
   FROM $TABLE_NAME
   $WHERE_CLAUSE)
FROM
  (SELECT $COLUMN_NAME,
          count(*)
   FROM $TABLE_NAME
   $WHERE_CLAUSE
   GROUP BY $COLUMN_NAME) t
WHERE t.count = 1
) TO STDOUT
" || echo "N/A"`

if [[ $turing_estimator == "N/A" ]]; then
  printf "  * Estimate: N/A\n" >> $OUTPUT_FILE
else
  printf "  * Estimate: %.3f\n"  $turing_estimator >> $OUTPUT_FILE
fi

# Return true in case "Error: devision by zero"

conf_interval=`python $UTIL_DIR/stats/good_turing_confidence_interval.py $num_samples $turing_estimator`

printf "  * 95%% Confidence interval: %s %s\n" $conf_interval >> $OUTPUT_FILE
