#! /bin/bash

# Usage: save.sh BASE OUTPUT CONFIG

# Do not stop on errors
# set -x # DEBUG

. $WORKING_DIR/braindump.conf

REPORT_DIR=$1
README="$REPORT_DIR/README.md"

touch $README

echo "# Statsitics" >> $README

# Stats for documents
# Hack: indent 4 spaces for better display
cat $REPORT_DIR/stats/documents.txt | sed 's/^/    /' >> $README

# Stats for each variable
num_variables=${#VARIABLE_TABLES[@]};
for (( i=0; i<${num_variables}; i++ )); do
	table=${VARIABLE_TABLES[$i]}
  echo "## Variable $table" >>$README
  cat $REPORT_DIR/stats/$table.txt | sed 's/^/    /' >>$README

  # If file exists
  if [[ -f "$REPORT_DIR/stats/${table}_top_entities.tsv" ]]; then
  	echo "### Most frequent entities" >>$README
  	head -n 10 $REPORT_DIR/stats/${table}_top_entities.tsv | sed 's/^/    /' >>$README;
  fi
done

# Stats for each feature
num_features=${#FEATURE_TABLES[@]}
for (( i=0; i<${num_features}; i++ )); do
  table=${FEATURE_TABLES[$i]}
  column=${FEATURE_COLUMNS[$i]}
  echo "## Feature table $table" >>$README
  cat $REPORT_DIR/stats/$table.txt >>$README
done

if [[ -f "$REPORT_DIR/features/weights/positive_features.tsv" ]]; then
  echo "### Top Positive Features" >>$README
  head -n 10 $REPORT_DIR/features/weights/positive_features.tsv | sed 's/^/    /' >>$README;
fi
if [[ -f "$REPORT_DIR/features/weights/positive_features.tsv" ]]; then
  echo "### Top Negative Features" >>$README
  head -n 10 $REPORT_DIR/features/weights/negative_features.tsv | sed 's/^/    /' >>$README;
fi

true
