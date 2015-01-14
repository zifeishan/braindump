#! /bin/bash

# Usage: stats.sh BASE OUTPUT CONFIG

set -e
# set -x # DEBUG

OUTPUT_DIR=$1
TABLE=$2
VAR_COLUMN=$3
# Naive entity linking: using mention words
WORDS=$4
DOCID=$5

set -u

touch $OUTPUT_DIR/$TABLE.txt

# Number of mentions
printf "* Number of mention candidates: %d\n" `psql $DBNAME -c " COPY (
  SELECT COUNT(*)
  FROM ${TABLE} ) TO STDOUT
  "` >> $OUTPUT_DIR/$TABLE.txt

# Positive / negative examples
# printf "Supervision statistics:\n" >> $OUTPUT_DIR/$TABLE.txt

printf "* Number of positive examples: %d\n" `psql $DBNAME -c " COPY (
  SELECT COUNT(*)
  FROM ${TABLE}
  WHERE $VAR_COLUMN = true
  ) TO STDOUT"` >> $OUTPUT_DIR/$TABLE.txt

printf "* Number of negative examples: %d\n" `psql $DBNAME -c " COPY (
  SELECT COUNT(*)
  FROM ${TABLE}
  WHERE $VAR_COLUMN = false
  ) TO STDOUT"` >> $OUTPUT_DIR/$TABLE.txt

printf "* Number of query variables: %d\n" `psql $DBNAME -c " COPY (
  SELECT COUNT(*)
  FROM ${TABLE}
  WHERE $VAR_COLUMN is null
  ) TO STDOUT"` >> $OUTPUT_DIR/$TABLE.txt

# Number of mentions
printf "* Number of extracted mentions with >0.9 expectation: %d\n" `psql $DBNAME -c " COPY (
  SELECT COUNT(*) AS extracted_mentions
  FROM ${TABLE}_${VAR_COLUMN}_inference
  WHERE expectation > 0.9
  ) TO STDOUT"` >> $OUTPUT_DIR/$TABLE.txt


# Number of distinct entities extracted
if [[ -n "$WORDS" ]]; then
  echo "Doing naive entity linking using exact match on column $WORDS...";

  psql $DBNAME -c "
    DROP VIEW IF EXISTS __${TABLE}_${VAR_COLUMN}_distinct_words CASCADE;

    CREATE VIEW __${TABLE}_${VAR_COLUMN}_distinct_words AS
      SELECT DISTINCT $WORDS
      FROM ${TABLE}_${VAR_COLUMN}_inference
      WHERE expectation > 0.9; 
  "

  printf "* Number of extracted entities with naive entity linking: %d\n" `psql $DBNAME -c " COPY (
    SELECT COUNT(*) AS extracted_entities
    FROM __${TABLE}_${VAR_COLUMN}_distinct_words
    ) TO STDOUT"` >> $OUTPUT_DIR/$TABLE.txt;

  # Good-turing estimator
  printf "* Good-Turing estimation of prob. that next extracted mention is new:\n" >> $OUTPUT_DIR/$TABLE.txt
  
  $UTIL_DIR/stats/good_turing_estimator.sh ${TABLE}_${VAR_COLUMN}_inference $WORDS $OUTPUT_DIR/$TABLE.txt "WHERE expectation > 0.9"

  if [ -f $OUTPUT_DIR/../coverage/${TABLE}.${VAR_COLUMN}.tsv ]; then
    # e.g. grep the line "0.90  0.730"
    printf "* Expected coverage at decision boundary 0.9: %.3f\n" \
    `cat $OUTPUT_DIR/../coverage/${TABLE}.${VAR_COLUMN}.tsv | grep '^0.90\t' | cut -f 2` >> $OUTPUT_DIR/$TABLE.txt
  fi

  # Most common entity
  psql $DBNAME -c "
  	DROP VIEW IF EXISTS __${TABLE}_${VAR_COLUMN}_histogram CASCADE;
  	
  	CREATE VIEW __${TABLE}_${VAR_COLUMN}_histogram 
  	AS  SELECT ${WORDS}, COUNT(*) as count
	  		FROM ${TABLE}_${VAR_COLUMN}_inference
	  		WHERE expectation > 0.9
	  		GROUP BY ${WORDS}
	  		ORDER BY count DESC, ${WORDS};";

	psql $DBNAME -c " COPY(
		SELECT * FROM __${TABLE}_${VAR_COLUMN}_histogram 
		ORDER BY count DESC, ${WORDS}
		LIMIT $NUM_TOP_ENTITIES
		) TO STDOUT
		" > $OUTPUT_DIR/${TABLE}_top_entities.tsv;
	echo "Saved into $OUTPUT_DIR/${TABLE}_top_entities.tsv"
	# cat $OUTPUT_DIR/${TABLE}_top_entities.tsv

  # Most common entity
  psql $DBNAME -c "
  	DROP VIEW IF EXISTS __${TABLE}_${VAR_COLUMN}_histogram CASCADE;";
fi

# distinct documents with extractions
if [[ -n "$DOCID" ]]; then
  printf "* Number of documents with extraction: %d\n" `psql $DBNAME -c "COPY (
    SELECT COUNT(distinct $DOCID) AS documents_with_extraction
    FROM ${TABLE}_${VAR_COLUMN}_inference
    WHERE expectation > 0.9 ) TO STDOUT
    "` >> $OUTPUT_DIR/$TABLE.txt
fi


# TODO entity linking table

# TODO a visualized histogram of mention / entity number