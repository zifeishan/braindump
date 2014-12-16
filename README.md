MindReporter
====

Creates automatic reports after each DeepDive run.


Configuration
----

Update `mindreporter.conf` to configure the report process.

This sample configuration file has been configured for 
`DEEPDIVE_HOME/examples/spouse_example/tsv_extractor`.

Warning
----

Now we use `git push` to send results. If you don't have `git push` access without password, please comment out the following line in `mindreporter.sh`:

    sh $UTIL_DIR/send-results.sh $REPORT_DIR/$versionName/ $versionName

Manual Run
----

Run

```
./mindreporter.sh
```

To manually generate a report after running.


Integrating with your DeepDive application
----

Suppose your app runs in `APP_HOME` and your outputs are saved in `DEEPDIVE_HOME/out`. Suppose you have a `run.sh` script that runs your application, and you want an automatic report each time after `run.sh` finishes.

1. Place the `mindreporter/` directory, `mindreporter.sh` and `mindreporter.conf` under your APP_HOME.

2. Add into the your `run.sh` a command to run `mindreporter.sh`. e.g. If your `run.sh` looks like:

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

### Run with deepdive binary:
deepdive -c $APP_HOME/application.conf

# Note that you should go back to your APP_HOME directory
cd $APP_HOME  
./mindreporter.sh
```


TODOs
====

Report items to add:

- # documents (if document table&column is present)
- # sentences (same above)

- Allow a home-brewed script to do the rest

- For each variable type:

  - extractions
  - (extractions by category: can use home-brewed script)

  - distinct documents with extractions
  - (same above)

  - Entity linking:
  - # distinct extractions
    - entity linking table
    - OR trivial no-linking (self-mapping)

  - most common mention / entity
  
  - mention / entity histograms

