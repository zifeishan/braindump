BrainDump
====

BrainDump is the automatic report generator for [DeepDive](http://deepdive.stanford.edu/). With
BrainDump, developers are able to get automated reports after each
DeepDive run, and delve into features, supervision, corpus statistics,
which makes error analysis for Knowledge Base Construction a bit
easier.

Please also refer to the [DeepDive tutorial](http://deepdive.stanford.edu/doc/basics/walkthrough/walkthrough-improve.html) that uses BrainDump.


Installation
----

### Dependencies

You can *optionally* install python library `click`, to use the
automatic configuration generation functionality. Run: 

```
pip install click
```

Alternatively, you can skip the automatic configuration functionality 
and manually configure `braindump.conf`.

### Install BrainDump

Run

```
make
```

to install `braindump` into `$HOME/local/bin/`. Be sure to include that in your `PATH` if you haven't:

```
export PATH=$PATH:$HOME/local/bin/
```


Configuration
----

To integrate BrainDump into your DeepDive application, first you need a `braindump.conf` file to specify the configuration to use BrainDump.

To set up `braindump.conf`, you can just run `braindump` once and it
will generate a `braindump.conf` in the current directory through an
interactive command line interface. Alternatively, modify the example
provided in `examples/tutorial_example/` --- this sample configuration
file has been configured for
`DEEPDIVE_HOME/examples/tutorial_example`.


Integrating with your DeepDive application
----

Suppose your app runs in `APP_HOME` and your outputs are saved in `DEEPDIVE_HOME/out`. Suppose you have a `run.sh` script that runs your application, and you want an automatic report each time after `run.sh` finishes:

Just add into the your `run.sh` a command to run `braindump`. e.g. If your `run.sh` looks like:

```
#! /bin/bash

. "$(dirname $0)/env.sh"

cd $DEEPDIVE_HOME

### Run with deepdive binary:
deepdive -c $APP_HOME/application.conf
```

Update it to look like this:

```
#! /bin/bash

. "$(dirname $0)/env.sh"

cd $DEEPDIVE_HOME

# Be sure to set this so that you are able to QUIT if deepdive fails.
set -e

# Run with deepdive binary:
deepdive -c $APP_HOME/application.conf

# Note that you should go back to your APP_HOME directory
cd $APP_HOME  
braindump
```

Experiment Report Directory
----

Each automated report will be generated as a directory of files. Here is one example directory hierarchy for `spouse_example`:

```
APP_HOME/experiment-reports/v00001/:
.
├── README.md                     -- (USEFUL) A short summary of the report, with most information needed!
├── calibration                   -- Calibration plots
│   ├── has_spouse.is_true.png
│   └── has_spouse.is_true.tsv
├── code                          -- Saved code for this run (default saves "application.conf" and "udf/")
│   ├── application.conf
│   └── udf
├── dd-out                        -- A symbolic link to the corresponding deepdive output directory
├── dd-timestamp                  -- A timestamp of this deepdive run
├── features                      -- Features
│   ├── counts                    -- A histogram of frequency for most frequent features
│   │   └── has_spouse_features.tsv
│   ├── samples                   -- A random sample of the feature table
│   │   └── has_spouse_features.csv
│   └── weights                   -- (USEFUL) Features with highest and lowest weights.
│       ├── negative_features.tsv
│       └── positive_features.tsv
├── inference                     -- A sample of inference results with >0.9 expectation. Can be used for Mindtagger input when configured.
│   └── has_spouse.csv
├── stats                         -- Statistics for this run
│   ├── documents.txt             -- Statistics for the whole corpus
│   ├── has_spouse.txt            -- Statistics for each variable
│   └── has_spouse_top_entities.tsv  -- A list of top extracted entities
└── supervision                   -- Supervision samples for both positive and negative examples.
    ├── has_spouse_false.csv
    └── has_spouse_true.csv

```

Example Configurations and Reports
----

You can browse some examples of configurations and reports, in `examples/` directory.

```
tutorial_example  -- BrainDump config and sample report for DeepDive tutorial
kbp-small         -- BrainDump config and sample report for a small KBP application
paleo-small       -- BrainDump config and sample report for a small Paleo application
genomics          -- BrainDump config for a genomics application
```

Common Diagnostics in KBC applications
----

After each `braindump` run, go into `experiment-reports/latest/`, and do following diagnostics:

### Diagnostics with README.md

- Look at README.md in your report directory. *(It looks better on Github. Try to push it!)*
- First, Understand your corpus statistics (how many documents and sentences do you have). Do they look correct?
- Look at each variable's statistics. You will be able to see statistics about mention candidates, positive and negative examples, extracted mentions and entities. Do they look correct? Do you have enough documents, positive and negative examples?
  - Look at the **"Good-Turing estimation"** of probability that *next extracted mention is unseen.* This includes an [estimator](http://en.wikipedia.org/wiki/Good%E2%80%93Turing_frequency_estimation) and a [confidence interval](http://www.cs.princeton.edu/~schapire/papers/good-turing.ps.gz). If the estimator is too high (e.g. higher than 0.05), or the upper bound of the confidence interval is too high (e.g. higher than 0.1), you are far away from exhausting your domain of extraction, and you may need to **add more data**.

- Look at top positive and negative features. Do they look reasonable? 
  - If a positive feature looks insane, why does it get high weight? Look at its number of positive examples and negative examples. Does it have enough negative examples correlated with this feature? If not, **add more negative examples** that may have this feature (and others), by **adding more data** or **adding additional supervision rules**.
  - Similarly, if a negative feature looks insane, why does it get low weight? Can you add positive examples with this feature?

- Look at the Good-Turing estimator for features. Similar with above, if you have a high estimator, your features are quite sparse.

- Look at the expected coverage of extractions with expectation 0.9. It estimates the recall of extraction with respect to extracted candidates. If this number is low, you may have lots of correct mentions generated as candidates but not getting a high expectation, and you may look into the supervision or features to diagnose that.

### Other diagnostics

If you configured `INFERENCE_SAMPLE_SCRIPT` properly --- see the [DeepDive tutorial](http://deepdive.stanford.edu/doc/basics/walkthrough/walkthrough-improve.html#braindump) and [Mindtagger docs](http://deepdive.stanford.edu/doc/basics/labeling.html) about how --- you can copy `inference/*.csv` into your MindTagger task as an input file of Mindtagger. Similarly you can do this for supervision results. See `examples/tutorial_example/bdconfigs/sample-inference.sh` to see how we configure this for DeepDive tutorial.

You are recommended to push the whole report onto Github: it's not large, and Github has good visualization for it. You can not only browse a beautified `README.md`, but also `features/weights/positive_features.tsv` and `features/weights/negative_features.tsv` in a very friendly way, to understand if current features make sense, and if you need more examples (more data or supervision rule).

For more diagnostics in KBC applications, please read [the feature engineering paper](http://arxiv.org/abs/1407.6439).


Configuration Specification
----

- `APP_HOME`: the base directory of the DeepDive application
- `DD_OUTPUT_DIR`: the output folder of DeepDive
- `DBNAME`: the name of your working database
- `PGUSER`: the user name to connect to database
- `PGPASSWORD`: the password of your database
- `PGPORT`: the port to connect to the database
- `PGHOST`: the host to connect to the database
- `FEATURE_TABLES`: all tables that contain features. Separated by space. e.g. "f1 f2 f3"
- `FEATURE_COLUMNS`: columns that contain features in the same order of FEATURE_TABLES. Separated by space. e.g. "c1 c2 c3"
- `VARIABLE_TABLES`: all tables that contain DeepDive variables (as defined in table schema). Separated by space. e.g. "v1 v2"
- `VARIABLE_COLUMNS`: variable columns in the same order of VARIABLE_TABLES. Separated by space. e.g. "v1 v2"
- `VARIABLE_WORDS_COLUMNS`: if the variable is a mention, specify the words / description for the mention. This is used for a statistics with naive entity linking. If empty (""), do not count deduplicated mentions for that table. Separated by space. e.g. w1 ""
- `VARIABLE_DOCID_COLUMNS`: specify if there is a field in the variable table that indicates doc_id. This is used to count how many documents have extractions. If empty (""), do not count for that table. Separated by space. e.g. "" did2
- `CODE_CONFIG`: a config file that specifies what in $APP_HOME to save as codes, one file/folder per line. Default file is saving "application.conf" and "udf".
- `NUM_SAMPLED_FEATURES`: the number of sampled features for each feature table specified in "FEATURE_TABLES"
- `NUM_SAMPLED_SUPERVISION`: the number of sampled supervision examples for each variable specified in "FEATURE_COLUMNS"
- `NUM_SAMPLED_RESULT`: the number of sampled inference results for each variable
- `NUM_TOP_ENTITIES`: the number of top extracted entities listed
- `SENTENCE_TABLE`: a table that contains all sentences
- `SENTENCE_TABLE_DOC_ID_COLUMN`: document_id column of the sentence table
- `SEND_RESULT_WITH_GIT`: whether to send the result with Git by creating a new commit in "experiment-reports" branch.
- `SEND_RESULT_WITH_GIT_PUSH`: whether to automate the push in the "experiment-reports" branch.
- `STATS_SCRIPT`: specify the path to a script to override default statistics reporting. The script will run instead of the default statistics reporting procedure.
- `SUPERVISION_SAMPLE_SCRIPT`: Specify a script to override default supervision sampling procedure.
- `INFERENCE_SAMPLE_SCRIPT`: Specify a script to override default inference result sampling procedure.
