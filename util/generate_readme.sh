#! /bin/bash

# Usage: save.sh BASE OUTPUT CONFIG

# Do not stop on errors
# set -x # DEBUG

. $WORKING_DIR/braindump.conf

REPORT_DIR=$1
README="$REPORT_DIR/README.md"

touch $README

printf "# Corpus Statsitics\n" >> $README

# Stats for documents
# Hack: indent 4 spaces for better display
cat $REPORT_DIR/stats/documents.txt >> $README

printf "\n" >> $README

printf "# Variables\n" >> $README

# Stats for each variable
num_variables=${#VARIABLE_TABLES[@]};
for (( i=0; i<${num_variables}; i++ )); do
	table=${VARIABLE_TABLES[$i]}
  printf "## Variable $table\n" >> $README
  cat $REPORT_DIR/stats/$table.txt >>$README

  # If file exists and is not empty
  if [[ -s "$REPORT_DIR/stats/${table}_top_entities.tsv" ]]; then
  	printf "\n### Most frequent entities\n" >>$README
  	head -n 10 $REPORT_DIR/stats/${table}_top_entities.tsv | sed 's/^/    /' >>$README;
  fi
  printf "\n" >> $README
done

printf "# Features\n" >>$README

if [[ -s "$REPORT_DIR/features/weights/positive_features.tsv" ]]; then
  printf "## Top Positive Features\n" >>$README
  head -n 10 $REPORT_DIR/features/weights/positive_features.tsv | sed 's/^/    /' >>$README;
  printf "\n" >> $README
fi
if [[ -s "$REPORT_DIR/features/weights/positive_features.tsv" ]]; then
  printf "## Top Negative Features\n" >>$README
  head -n 10 $REPORT_DIR/features/weights/negative_features.tsv | sed 's/^/    /' >>$README;
  printf "\n" >> $README
fi

# Stats for each feature
num_features=${#FEATURE_TABLES[@]}
for (( i=0; i<${num_features}; i++ )); do
  table=${FEATURE_TABLES[$i]}
  column=${FEATURE_COLUMNS[$i]}
  printf "## Feature table $table\n" >>$README
  cat $REPORT_DIR/stats/$table.txt >>$README
  printf "\n" >> $README

  if [[ -s "$REPORT_DIR/features/counts/$table.tsv" ]]; then
    printf "### Most frequent features for $table\n" >>$README
    head -n 10 $REPORT_DIR/features/counts/$table.tsv | sed 's/^/    /' >>$README;
    printf "\n" >> $README
  fi
done


true
