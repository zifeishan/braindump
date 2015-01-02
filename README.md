BrainDump
====

Creates automatic reports after each DeepDive run.


Installation
----

### Dependencies

You need python library `click` to use the automatic configuration 
functionality. Run: ```pip install click```

Alternatively, you can skip the automatic configuration functionality 
and manually configure `braindump.conf`.

### Install

Run

```
make
```

to install `braindump` into `$HOME/local/bin/`. Be sure to include that in your PATH if you haven't:

`export PATH=$PATH:$HOME/local/bin/`

Configuration
----

To integrate BrainDump into your DeepDive application, first you need a `braindump.conf` file to specify the configuration to use BrainDump.

To set up `braindump.conf`, you can just run `braindump` once and it
will generate a `braindump.conf` in the current directory through an
interactive command line interface. Alternatively, modify the example
provided in `examples/spouse_custom/` --- this sample configuration
file has been configured for
`DEEPDIVE_HOME/examples/spouse_example/tsv_extractor`.


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
├── README.md                     -- A short summary of the report
├── calibration                   -- Calibration plots
│   ├── has_spouse.is_true.png
│   └── has_spouse.is_true.tsv
├── code                          -- Saved code for this run
│   ├── application.conf
│   └── udf
│       ├── ext_has_spouse.py
│       ├── ext_has_spouse_features.py
│       └── ext_people.py
├── dd-out                        -- A symbolink to the corresponding deepdive output directory
├── dd-timestamp                  -- A timestamp of this deepdive run
├── features                      -- Features
│   ├── counts                    -- A histogram of frequency for most frequent features
│   │   └── has_spouse_features.tsv
│   ├── samples                   -- A random sample of the feature table
│   │   └── has_spouse_features.csv
│   └── weights                   -- Features with highest and lowest weights. Important features.
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
