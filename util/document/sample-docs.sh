# Sample documents for recall mode. The sampled documents can be used for labeling. 

# After users label all the mentions in the table, the results should be put into a database table,
# and BrainDump can use this to assess the quality of candidate generation.

set -u

OUTPUT_FILE=$1
SENTENCE_TABLE=$2
DOCID_COLUMN=$3
SENTID_COLUMN=${4:-sentence_offset}
WORDS_COLUMN=${5:-words}
NUM_SAMPLED_DOCS=${NUM_SAMPLED_DOCS:-100}

# DEBUG
echo "Sampling $NUM_SAMPLED_DOCS documents..."
# Create a table that contains all sampled document IDs
psql $DBNAME -c "
DROP TABLE IF EXISTS __sampled_docs_for_recall CASCADE;

CREATE TABLE __sampled_docs_for_recall AS
SELECT $DOCID_COLUMN FROM $SENTENCE_TABLE GROUP BY $DOCID_COLUMN
ORDER BY RANDOM() LIMIT ${NUM_SAMPLED_DOCS};
"

# Sample documents into output file
psql $DBNAME -c " COPY (
SELECT $DOCID_COLUMN as doc_id
     , $SENTID_COLUMN as sent_id
     , $WORDS_COLUMN as words
FROM $SENTENCE_TABLE
WHERE $DOCID_COLUMN IN (select * from __sampled_docs_for_recall)
ORDER BY $DOCID_COLUMN, $SENTID_COLUMN

) TO STDOUT CSV HEADER" > $OUTPUT_FILE

