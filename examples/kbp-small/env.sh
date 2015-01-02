#! /bin/bash

export DBNAME=deepdive_kbp_zifei
export PGUSER=senwu
export PGPASSWORD=${PGPASSWORD:-}
export PGHOST=raiders4.stanford.edu
export PGPORT=6432

export GPHOST=${GPHOST:-localhost}
export GPPORT=${GPPORT:-15433}
export GPPATH=${GPPATH:-/tmp}
# . /lfs/local/0/senwu/software/greenplum/greenplum-db/before_greenplum.sh