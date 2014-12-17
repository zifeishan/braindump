#! /bin/bash

set -e
# set -x # DEBUG MODE

# Import the configuration file
# . "$(dirname $0)/mindreporter.conf"

# conf file is in current directory
. `pwd`/mindreporter.conf

mkdir -p $REPORT_DIR

# Decide the version to save as
for ((verNumber=1; ;verNumber+=1)); do
  # Directory name: "v00001", etc
  versionName=v`printf "%05d" $verNumber`
  
  # if directory doesn't exist.
  if [ ! -d "$REPORT_DIR/$versionName" ]; then
    
    echo "Saving into $REPORT_DIR/$versionName/"

    mkdir -p $REPORT_DIR/$versionName/
    cd $REPORT_DIR/$versionName/

    echo "Saving mapping with DeepDive output directory..."
    ln -s $DD_THIS_OUTPUT_DIR ./dd-out
    echo $DD_TIMESTAMP > ./dd-timestamp

    echo "Saving code..."
    mkdir -p code
    bash $UTIL_DIR/save.sh $APP_HOME ./code/

    echo "Saving calibration..."
    cp -r $DD_THIS_OUTPUT_DIR/calibration ./

    echo "Saving statistics..."  
    bash $UTIL_DIR/stats.sh $VARIABLE_TABLES $VARIABLE_COLUMNS $VARIABLE_WORDS_COLUMNS 

    echo "Diffing against last version..."
    if [ $verNumber -gt 1 ]; then
      mkdir -p changes
      lastVersionName=v`printf "%05d" $(expr $verNumber - 1)`
      bash $UTIL_DIR/diff.sh ../$lastVersionName/code/ ./code/ changes/code.diff
      bash $UTIL_DIR/diff.sh ../$lastVersionName/stats/ ./stats/ changes/stats.diff
    fi

    echo "Saving features..."
    mkdir -p features

    mkdir -p features/weights/
    bash $UTIL_DIR/feature/feature_weights.sh features/weights/

    num_features=${#FEATURE_TABLES[@]}
    echo "Examining $num_features feature tables..."
    for (( i=0; i<${num_features}; i++ )); do
      table=${FEATURE_TABLES[$i]}
      column=${FEATURE_COLUMNS[$i]}

      # Samples in CSV with header
      mkdir -p features/samples/
      bash $UTIL_DIR/feature/feature_samples.sh $table features/samples/

      mkdir -p features/counts/
      bash $UTIL_DIR/feature/feature_counts.sh $table $column features/counts/
    done

    echo "Saving supervision & inference results..."
    mkdir -p inference
    mkdir -p supervision

    if [[ -z "$SUPERVISION_SAMPLE_SCRIPT" ]]; then
      # Supervision sample script not set, use default
      num_variables=${#VARIABLE_TABLES[@]};
      echo "Examining $num_variables variable tables...";
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
      # Supervision sample script not set, use default
      num_variables=${#VARIABLE_TABLES[@]};
      echo "Examining $num_variables variable tables...";
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

    echo "Generating README.md..."
    cd ../../
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