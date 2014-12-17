set -e
# set -x # DEBUG

. $WORKING_DIR/mindreporter.conf


OUTPUT_DIR=$APP_HOME/stats
mkdir -p $OUTPUT_DIR

if [[ -z "$STATS_SCRIPT" ]]; then
  # Supervision sample script not set, use default

  # Global stats
  bash $UTIL_DIR/stats/global.sh $OUTPUT_DIR

  # Stats for each variable
  num_variables=${#VARIABLE_TABLES[@]};
  echo "Examining $num_variables variable tables...";
  for (( i=0; i<${num_variables}; i++ )); do
    table=${VARIABLE_TABLES[$i]}
    column=${VARIABLE_COLUMNS[$i]}
    words=
    docid=
    if [[ -n "$VARIABLE_WORDS_COLUMNS" ]]; then
      words=${VARIABLE_WORDS_COLUMNS[$i]}
    fi
    if [[ -n "$VARIABLE_DOCID_COLUMNS" ]]; then
      docid=${VARIABLE_DOCID_COLUMNS[$i]}
    fi

    bash $UTIL_DIR/stats/single_variable.sh $OUTPUT_DIR $table $column $words $docid

  done;
else
  # Just run the user-defined script
  bash $STATS_SCRIPT
fi
