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
psql $DBNAME -c "
  SELECT COUNT(*) as mention_candidates
  FROM ${TABLE}
  " >> $OUTPUT_DIR/$TABLE.txt

# Positive / negative examples
echo "Supervision statistics:" >> $OUTPUT_DIR/$TABLE.txt

psql $DBNAME -c "
  SELECT ${VAR_COLUMN}, COUNT(*)
  FROM ${TABLE}
  GROUP BY $VAR_COLUMN
  " >> $OUTPUT_DIR/$TABLE.txt

# Number of mentions
psql $DBNAME -c "
  SELECT COUNT(*) AS extracted_mentions
  FROM ${TABLE}_${VAR_COLUMN}_inference
  WHERE expectation > 0.9;
  " >> $OUTPUT_DIR/$TABLE.txt


# Number of distinct entities extracted
if [[ -n "$WORDS" ]]; then
  echo "Doing naive entity linking using exact match on column $WORDS...";

  psql $DBNAME -c "
    SELECT COUNT(distinct $WORDS) AS extracted_entities
    FROM ${TABLE}_${VAR_COLUMN}_inference
    WHERE expectation > 0.9;
    " >> $OUTPUT_DIR/$TABLE.txt;

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
  echo "Doing naive entity linking using exact match on column $DOCID..."
  psql $DBNAME -c "
    SELECT COUNT(distinct $DOCID) AS documents_with_extraction
    FROM ${TABLE}_${VAR_COLUMN}_inference
    WHERE expectation > 0.9;
    " >> $OUTPUT_DIR/$TABLE.txt
fi


# TODO entity linking table

# TODO a visualized histogram of mention / entity number