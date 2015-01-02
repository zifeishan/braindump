#! /bin/bash

export DBNAME=genomics
export PGUSER=senwu
export PGPASSWORD=${PGPASSWORD:-}
export PGHOST=raiders2.stanford.edu
export PGPORT=6432

export GPHOST=${GPHOST:-localhost}
export GPPORT=${GPPORT:-15433}
export GPPATH=${GPPATH:-/tmp}
# . /lfs/local/0/senwu/software/greenplum/greenplum-db/before_greenplum.sh
