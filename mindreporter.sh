#! /bin/bash

set -eu
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
    sh $UTIL_DIR/save.sh $APP_HOME ./code/ $UTIL_DIR/code_default.conf

    echo "Diffing against last version..."
    if [ $verNumber -gt 1 ]; then
      mkdir -p changes
      lastVersionName=v`printf "%05d" $(expr $verNumber - 1)`
      sh $UTIL_DIR/diff.sh ../$lastVersionName/code/ ./code/ > changes/code.diff      
    fi

    echo "Saving calibration..."
    cp -r $DD_THIS_OUTPUT_DIR/calibration ./

    echo "Saving features..."
    mkdir -p features

    mkdir -p features/weights/
    sh $UTIL_DIR/feature/feature_weights.sh features/weights/

    num_features=${#FEATURE_TABLES[@]}
    echo "Examining $num_features feature tables..."
    for (( i=0; i<${num_features}; i++ )); do
      table=${FEATURE_TABLES[$i]}
      column=${FEATURE_COLUMNS[$i]}

      # Samples in CSV with header
      mkdir -p features/samples/
      sh $UTIL_DIR/feature/feature_samples.sh $table features/samples/

      mkdir -p features/counts/
      sh $UTIL_DIR/feature/feature_counts.sh $table $column features/counts/
    done

    echo "Saving supervision & inference results..."
    mkdir -p inference
    mkdir -p supervision
    num_variables=${#VARIABLE_TABLES[@]}
    echo "Examining $num_variables variable tables..."
    for (( i=0; i<${num_variables}; i++ )); do
      table=${VARIABLE_TABLES[$i]}
      column=${VARIABLE_COLUMNS[$i]}

      # Sample supervision labels
      sh $UTIL_DIR/variable/supervision_samples.sh $table $column supervision/

      # Sample inference results
      sh $UTIL_DIR/variable/inference_result.sh $table $column inference/
    done

    ## echo "Pushing into remote git repository. Make sure you are in SSH mode for git."
    # sh $UTIL_DIR/send-results.sh $REPORT_DIR/$versionName/ $versionName

    break
  fi
  
done

