OUTPUT_DIR=$1

psql -d $DBNAME -c "COPY (
  SELECT description, weight
  FROM dd_inference_result_variables_mapped_weights 
  ORDER BY weight DESC 
  LIMIT ${NUM_SAMPLED_FEATURES}
) TO STDOUT;" > $OUTPUT_DIR/positive_features.tsv

psql -d $DBNAME -c "COPY (
  SELECT description, weight
  FROM dd_inference_result_variables_mapped_weights 
  ORDER BY weight ASC 
  LIMIT ${NUM_SAMPLED_FEATURES}
) TO STDOUT;" > $OUTPUT_DIR/negative_features.tsv

