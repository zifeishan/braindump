TABLE=$1
OUTPUT_DIR=$2

psql -d $DBNAME -c "COPY (
  SELECT * 
  FROM $TABLE 
  ORDER BY RANDOM() 
  LIMIT 100
) TO STDOUT HEADER CSV;" > $OUTPUT_DIR/$TABLE.csv
