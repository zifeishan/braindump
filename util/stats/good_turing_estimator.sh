#! /bin/bash

TABLE_NAME=$1
COLUMN_NAME=$2
WHERE_CLAUSE=${3:-}

# Use WHERE clause to filter all mentions if presents.
psql $DBNAME -c " COPY (
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
"

# TODO devision by zero