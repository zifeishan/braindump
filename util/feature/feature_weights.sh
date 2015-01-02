OUTPUT_DIR=$1

# Test if the feature statistics table exists
psql -d $DBNAME -c "\d dd_feature_statistics" >/dev/null

if [ $? -eq 0 ]; then

  # Sample features with #pos/neg examples
  psql -d $DBNAME -c "COPY (
    SELECT description, weight, pos_examples, neg_examples, queries
    FROM dd_feature_statistics 
    ORDER BY weight DESC 
    LIMIT ${NUM_SAMPLED_FEATURES}
  ) TO STDOUT HEADER;" > $OUTPUT_DIR/positive_features.tsv

  psql -d $DBNAME -c "COPY (
    SELECT description, weight, pos_examples, neg_examples, queries
    FROM dd_feature_statistics 
    ORDER BY weight ASC 
    LIMIT ${NUM_SAMPLED_FEATURES}
  ) TO STDOUT HEADER;" > $OUTPUT_DIR/negative_features.tsv

else

  psql -d $DBNAME -c "COPY (
    SELECT description, weight
    FROM dd_inference_result_variables_mapped_weights 
    ORDER BY weight DESC 
    LIMIT ${NUM_SAMPLED_FEATURES}
  ) TO STDOUT HEADER;" > $OUTPUT_DIR/positive_features.tsv

  psql -d $DBNAME -c "COPY (
    SELECT description, weight
    FROM dd_inference_result_variables_mapped_weights 
    ORDER BY weight ASC 
    LIMIT ${NUM_SAMPLED_FEATURES}
  ) TO STDOUT HEADER;" > $OUTPUT_DIR/negative_features.tsv

fi
