MindReporter
====

Creates automatic reports after each DeepDive run.


Configuration
----

Update `mindreporter.conf` to configure the report process. See `examples/spouse_custom/` for example usage.

This sample configuration file has been configured for 
`DEEPDIVE_HOME/examples/spouse_example/tsv_extractor`.

Installation
----

Run

```
make
```

To install `mindreporter` into `$HOME/local/bin/`. Be sure to include that in your PATH if you haven't:

`export PATH=$PATH:$HOME/local/bin/`

Integrating with your DeepDive application
----

Suppose your app runs in `APP_HOME` and your outputs are saved in `DEEPDIVE_HOME/out`. Suppose you have a `run.sh` script that runs your application, and you want an automatic report each time after `run.sh` finishes.

<!-- 1. Place the `mindreporter/` directory, `mindreporter.sh` and `mindreporter.conf` under your APP_HOME.
 -->

- Add into the your `run.sh` a command to run `mindreporter`. e.g. If your `run.sh` looks like:

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
mindreporter
```
