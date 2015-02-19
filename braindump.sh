#! /bin/bash

set -e
# set -x # DEBUG MODE

export WORKING_DIR=`pwd`

BD_CONF_FILE=${1:-$WORKING_DIR/braindump.conf}
# . "$(dirname $0)/env.sh" $(dirname $BD_CONF_FILE)/$BD_CONF_FILE
export BD_CONF_FILE="$(cd "$(dirname "$BD_CONF_FILE")"; pwd)/$(basename "$BD_CONF_FILE")"

if [[ ! -f $BD_CONF_FILE ]]; then
  echo "Configuration file not found!"
  echo "Running braindump-configure to set up a configuration file..."
  braindump-configure
  exit 0
fi

# Import the configuration file
# conf file is in current directory
. $WORKING_DIR/braindump.conf

echo "Dumping $DBNAME, host: $PGHOST, port:$PGPORT, user: $PGUSER"
mkdir -p $REPORT_DIR

# Decide the version to save as
for ((verNumber=1; ;verNumber+=1)); do
  # Directory name: "v00001", etc
  versionName=v`printf "%05d" $verNumber`
  
  # if directory doesn't exist.
  if [ ! -d "$REPORT_DIR/$versionName" ]; then
    
    echo "[`date`] Saving into $REPORT_DIR/$versionName/"

    mkdir -p $REPORT_DIR/$versionName/
    cd $REPORT_DIR/$versionName/

    # Skip if last DeepDive run is not finished
    if [ -d $DD_THIS_OUTPUT_DIR/calibration ]; then
      echo "[`date`] Saving mapping with DeepDive output directory..."
      ln -s $DD_THIS_OUTPUT_DIR ./dd-out
      echo $DD_TIMESTAMP > ./dd-timestamp

      echo "[`date`] Saving code..."
      mkdir -p code
      bash $UTIL_DIR/save.sh $APP_HOME ./code/

      echo "[`date`] Saving calibration..."
      cp -r $DD_THIS_OUTPUT_DIR/calibration ./
    else
      echo "WARNING: last deepdive run $DD_THIS_OUTPUT_DIR seems incomplete, skipping..."
    fi

    echo "[`date`] Compute extraction coverages..."
    mkdir -p coverage
    num_variables=${#VARIABLE_TABLES[@]};
    echo "[`date`] Examining $num_variables variable tables for coverage...";
    for (( i=0; i<${num_variables}; i++ )); do
      table_name=${VARIABLE_TABLES[$i]}
      column_name=${VARIABLE_COLUMNS[$i]}
      bash $UTIL_DIR/calibration/coverage.sh ./coverage $table_name $column_name
    done

    # Do not sample if the sample table exists
    exists=true; psql $DBNAME -c "\d __sampled_docs_for_recall" >/dev/null || exists=false
    if [ $exists == false ]; then
      echo "[`date`] Sampling documents for labeling..."
      mkdir -p document/label_documents
      bash $UTIL_DIR/document/sample-docs.sh \
        ./document/label_documents/sampled_documents.csv \
        $SENTENCE_TABLE \
        $SENTENCE_TABLE_DOC_ID_COLUMN \
        $SENTENCE_TABLE_SENT_OFFSET_COLUMN \
        $SENTENCE_TABLE_WORDS_COLUMN
      # Pass the variable table array to generate template
      $UTIL_DIR/document/generate-template.py ${VARIABLE_TABLES[@]} > document/label_documents/template.html
      # Copy mindtagger starter and conf
      cp -f $UTIL_DIR/document/mindtagger.conf document/label_documents/
      cp -f $UTIL_DIR/document/start-mindtagger.sh document/
    fi

    echo "[`date`] Saving statistics..."  
    bash $UTIL_DIR/stats.sh $VARIABLE_TABLES $VARIABLE_COLUMNS $VARIABLE_WORDS_COLUMNS 

    echo "[`date`] Diffing against last version..."
    if [ $verNumber -gt 1 ]; then
      mkdir -p changes
      lastVersionName=v`printf "%05d" $(expr $verNumber - 1)`
      bash $UTIL_DIR/diff.sh ../$lastVersionName/code/ ./code/ changes/code.diff
      bash $UTIL_DIR/diff.sh ../$lastVersionName/stats/ ./stats/ changes/stats.diff
    fi

    echo "[`date`] Saving features..."
    mkdir -p features

    mkdir -p features/weights/
    bash $UTIL_DIR/feature/feature_weights.sh features/weights/

    num_features=${#FEATURE_TABLES[@]}
    echo "[`date`] Examining $num_features feature tables..."
    for (( i=0; i<${num_features}; i++ )); do
      table=${FEATURE_TABLES[$i]}
      column=${FEATURE_COLUMNS[$i]}

      # Samples in CSV with header
      mkdir -p features/samples/
      bash $UTIL_DIR/feature/feature_samples.sh $table features/samples/

      mkdir -p features/counts/
      bash $UTIL_DIR/feature/feature_counts.sh $table $column features/counts/
    done

    echo "[`date`] Saving supervision & inference results..."
    mkdir -p inference
    mkdir -p supervision

    if [[ -z "$SUPERVISION_SAMPLE_SCRIPT" ]]; then
      # Supervision sample script not set, use default
      num_variables=${#VARIABLE_TABLES[@]};
      echo "[`date`] Examining $num_variables variable tables for supervision...";
      for (( i=0; i<${num_variables}; i++ )); do
        table=${VARIABLE_TABLES[$i]}
        column=${VARIABLE_COLUMNS[$i]}

        # Sample supervision labels
        bash $UTIL_DIR/variable/supervision_samples.sh $table $column supervision/

        # # Sample inference results
        # bash $UTIL_DIR/variable/inference_result.sh $table $column inference/
      done;
    else
      # Just run the user-defined script
      bash $SUPERVISION_SAMPLE_SCRIPT
    fi

    if [[ -z "$INFERENCE_SAMPLE_SCRIPT" ]]; then
      # Inference sample script not set, use default
      num_variables=${#VARIABLE_TABLES[@]};
      echo "[`date`] Examining $num_variables variable tables for inference...";
      for (( i=0; i<${num_variables}; i++ )); do
        table=${VARIABLE_TABLES[$i]}
        column=${VARIABLE_COLUMNS[$i]}

        # Sample inference results
        bash $UTIL_DIR/variable/inference_result.sh $table $column inference/
      done;
    else
      # Just run the user-defined script
      bash $INFERENCE_SAMPLE_SCRIPT
    fi

    echo "[`date`] Generating README.md..."
    bash $UTIL_DIR/generate_readme.sh $REPORT_DIR/$versionName/

    if [[ "$SEND_RESULT_WITH_GIT" = "true" ]]; then
      # echo "Pushing into remote git repository. Make sure you are in SSH mode for git."
      bash $UTIL_DIR/send-results-git.sh $REPORT_DIR/$versionName/ $versionName
    fi
    if [[ "$SEND_RESULT_WITH_EMAIL" = "true" ]]; then
      # NOT IMPLEMENTED YET
      # bash $UTIL_DIR/send-results-email.sh $REPORT_DIR/$versionName/ $versionName
      true
    fi
    break
  fi
  
done

# Create a symbolic link
rm -f $REPORT_DIR/latest
ln -s $REPORT_DIR/$versionName/ $REPORT_DIR/latest

echo "[suceess] Report is written into $REPORT_DIR/$versionName/"
