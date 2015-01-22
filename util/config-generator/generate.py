#! /usr/bin/env python
# -*- coding: utf-8 -*-

import sys

# Requires click librar. Install: `pip install click`
import click


@click.command()
@click.option('--output_file', '-o', 
              prompt='Specify the output path of the generated config file',
              default='braindump.conf',
              help='output path of generated config file')
@click.option('--app_home',
              prompt='Specify APP_HOME, the base directory of the DeepDive application',
              default='$WORKING_DIR',
              help='the base directory of the DeepDive application')
@click.option('--dd_output_dir', 
              prompt='Specify DD_OUTPUT_DIR, the output folder of DeepDive',
              default='"$WORKING_DIR/../../out"',
              help='the output folder of DeepDive')
@click.option('--dbname', 
              prompt='Specify DBNAME, the name of your working database',
              default='$DBNAME',
              help='the name of your working database')
@click.option('--pguser', 
              prompt='Specify PGUSER, the user name to connect to database',
              default='${PGUSER:-`whoami`}',
              help='the user name to connect to database')
@click.option('--pgpassword', 
              prompt='Specify PGPASSWORD, the password of your database',
              default='${PGPASSWORD:-}',
              help='the password of your database')
@click.option('--pgport', 
              prompt='Specify PGPORT, the port to connect to the database',
              default='${PGPORT:-5432}',
              help='the port to connect to the database')
@click.option('--pghost', 
              prompt='Specify PGHOST, the host to connect to the database',
              default='${PGHOST:-localhost}',
              help='the host to connect to the database')
@click.option('--feature_tables', 
              prompt='Specify FEATURE_TABLES, all tables that contain features. Separated by space. e.g. "f1 f2 f3"',
              default='',
              help='all tables that contain features. Separated by space. e.g. "f1 f2 f3"')
@click.option('--feature_columns', 
              prompt='Specify FEATURE_COLUMNS, columns that contain features in the same order of FEATURE_TABLES. Separated by space. e.g. "c1 c2 c3"',
              default='',
              help='columns that contain features in the same order of FEATURE_TABLES. Separated by space. e.g. "c1 c2 c3"')
@click.option('--variable_tables', 
              prompt='Specify VARIABLE_TABLES, all tables that contain DeepDive variables (as defined in table schema). Separated by space. e.g. "v1 v2"',
              default='',
              help='all tables that contain DeepDive variables (as defined in table schema). Separated by space. e.g. "v1 v2"')
@click.option('--variable_columns', 
              prompt='Specify VARIABLE_COLUMNS, variable columns in the same order of VARIABLE_TABLES. Separated by space. e.g. "v1 v2"',
              default='',
              help='variable columns in the same order of VARIABLE_TABLES. Separated by space. e.g. "v1 v2"')
@click.option('--variable_words_columns', 
              prompt='Specify VARIABLE_WORDS_COLUMNS, if the variable is a mention, specify the words / description for the mention. This is used for a statistics with naive entity linking. If empty (""), do not count deduplicated mentions for that table. Separated by space. e.g. w1 ""',
              default='',
              help='if the variable is a mention, specify the words / description for the mention. This is used for a statistics with naive entity linking. If empty (""), do not count deduplicated mentions for that table. Separated by space. e.g. w1 ""')
@click.option('--variable_docid_columns', 
              prompt='Specify VARIABLE_DOCID_COLUMNS, if there is a field in the variable table that indicates doc_id. This is used to count how many documents have extractions. If empty (""), do not count for that table. Separated by space. e.g. "" did2',
              default='',
              help='specify if there is a field in the variable table that indicates doc_id. This is used to count how many documents have extractions. If empty (""), do not count for that table. Separated by space. e.g. "" did2')
@click.option('--code_config', 
              prompt='Specify CODE_CONFIG, a config file that specifies what in $APP_HOME to save as codes, one file/folder per line. Default file is: \napplication.conf\nudf',
              default='',
              help='a config file that specifies what in $APP_HOME to save as codes, one file/folder per line. Default file is: \napplication.conf\nudf\n')
@click.option('--num_sampled_docs', 
              prompt='Specify NUM_SAMPLED_DOCS',
              default='100',
              help='')
@click.option('--num_sampled_features', 
              prompt='Specify NUM_SAMPLED_FEATURES',
              default='100',
              help='')
@click.option('--num_sampled_supervision', 
              prompt='Specify NUM_SAMPLED_SUPERVISION',
              default='500',
              help='')
@click.option('--num_sampled_result', 
              prompt='Specify NUM_SAMPLED_RESULT',
              default='1000',
              help='')
@click.option('--num_top_entities', 
              prompt='Specify NUM_TOP_ENTITIES',
              default='50',
              help='')
@click.option('--sentence_table', 
              prompt='Specify SENTENCE_TABLE',
              default='sentences',
              help='')
@click.option('--sentence_table_doc_id_column', 
              prompt='Specify SENTENCE_TABLE_DOC_ID_COLUMN',
              default='document_id',
              help='')
@click.option('--sentence_table_sent_offset_column', 
              prompt='Specify SENTENCE_TABLE_SENT_OFFSET_COLUMN',
              default='sentence_offset',
              help='')
@click.option('--sentence_table_words_column', 
              prompt='Specify SENTENCE_TABLE_WORDS_COLUMN',
              default='words',
              help='')
@click.option('--send_result_with_git', 
              prompt='Specify SEND_RESULT_WITH_GIT',
              default='false',
              help='')
@click.option('--send_result_with_git_push', 
              prompt='Specify SEND_RESULT_WITH_GIT_PUSH',
              default='false',
              help='')
@click.option('--send_result_with_email', 
              prompt='Specify SEND_RESULT_WITH_EMAIL',
              default='false',
              help='')
@click.option('--stats_script', 
              prompt='Specify STATS_SCRIPT, a script to override default statistics reporting',
              default='',
              help='a script to override default statistics reporting')
@click.option('--supervision_sample_script', 
              prompt='Specify SUPERVISION_SAMPLE_SCRIPT, a script to override default supervision sampling',
              default='',
              help='a script to override default supervision sampling')
@click.option('--inference_sample_script', 
              prompt='Specify INFERENCE_SAMPLE_SCRIPT, a script to override default inference result sampling',
              default='',
              help='a script to override default inference result sampling')
def generate(output_file, 
              app_home, 
              dd_output_dir, 
              dbname, 
              pguser, 
              pgpassword, 
              pgport, 
              pghost, 
              feature_tables, 
              feature_columns, 
              variable_tables, 
              variable_columns, 
              variable_words_columns, 
              variable_docid_columns, 
              code_config, 
              num_sampled_docs,
              num_sampled_features, 
              num_sampled_supervision, 
              num_sampled_result, 
              num_top_entities, 
              sentence_table, 
              sentence_table_doc_id_column, 
              sentence_table_sent_offset_column,
              sentence_table_words_column,
              send_result_with_git, 
              send_result_with_git_push, 
              send_result_with_email, 
              stats_script, 
              supervision_sample_script, 
              inference_sample_script):
    """A program that generates braindump.conf"""

    click.echo(file=open(output_file, 'w'), message='''
########## Conventions. Do not recommend to change. ###########

# Set the utility files dir
export UTIL_DIR="$HOME/local/braindump"

# Report folder: use current
export REPORT_DIR="$WORKING_DIR/experiment-reports"


########## User-specified configurations ###########

# Directories

# Use absolute path if possible.
# Avoid using "pwd" or "dirname $0", they don't work properly.
# $WORKING_DIR is set to be the directory where braindump is running. 
# (the directory that contains braindump.conf)
export APP_HOME=%s

# Specify deepdive out directory (DEEPDIVE_HOME/out)
export DD_OUTPUT_DIR=%s

# Database Configuration
export DBNAME=%s
export PGUSER=%s
export PGPASSWORD=%s
export PGPORT=%s
export PGHOST=%s

# Specify all feature tables. 
# e.g. FEATURE_TABLES=(f1 f2 f3)
export FEATURE_TABLES=(%s)
export FEATURE_COLUMNS=(%s)

# Specify all variable tables
export VARIABLE_TABLES=(%s)
export VARIABLE_COLUMNS=(%s)
# Assume that in DeepDive, inference result tables will be named as [VARIABLE_TABLE]_[VARIABLE_COLUMN]_inference

# If the variable is a mention, specify the words / description for the mention. 
# This is used for a statistics with naive entity linking. If empty, do not count deduplicated mentions.
# e.g. export VARIABLE_WORDS_COLUMNS=(w1 "" w3)
# In the examples above, the second element is left empty
export VARIABLE_WORDS_COLUMNS=(%s)

# Set variable docid columns to count distinct documents that have extractions
# export VARIABLE_DOCID_COLUMNS=(%s)

# Code configs to save
export CODE_CONFIG=%s

# Number of samples
export NUM_SAMPLED_DOCS=%s
export NUM_SAMPLED_FEATURES=%s
export NUM_SAMPLED_SUPERVISION=%s
export NUM_SAMPLED_RESULT=%s
export NUM_TOP_ENTITIES=%s

# Specify some tables for statistics
export SENTENCE_TABLE=%s
export SENTENCE_TABLE_DOC_ID_COLUMN=%s
export SENTENCE_TABLE_SENT_OFFSET_COLUMN=%s
export SENTENCE_TABLE_WORDS_COLUMN=%s

# Define how to send result. use "true" to activate.
export SEND_RESULT_WITH_GIT=%s
# If true, push after commiting the report
export SEND_RESULT_WITH_GIT_PUSH=%s
export SEND_RESULT_WITH_EMAIL=%s

######## CUSTOM SCRIPTS ###########
# Leave blank for default stats report.
# Set to a location of a script (e.g. $APP_HOME/your_script) to use it instead of default 

# Self-defined scripts for stats. 
export STATS_SCRIPT=%s
export SUPERVISION_SAMPLE_SCRIPT=%s
export INFERENCE_SAMPLE_SCRIPT=%s

########## Conventions. Do not recommend to change. ###########

# Hack: use the last DD run as output dir
# Suppose out/ is under $DEEPDIVE_HOME/
# You may need to manually change it based on need
export DD_TIMESTAMP=`ls -t $DD_OUTPUT_DIR/ | head -n 1`
export DD_THIS_OUTPUT_DIR=$DD_OUTPUT_DIR/$DD_TIMESTAMP
''' % (app_home, dd_output_dir, dbname, pguser, pgpassword, pgport, pghost, feature_tables, feature_columns, variable_tables, variable_columns, variable_words_columns, variable_docid_columns, code_config, num_sampled_docs, num_sampled_features, num_sampled_supervision, num_sampled_result, num_top_entities, sentence_table, sentence_table_doc_id_column, sentence_table_sent_offset_column, sentence_table_words_column, send_result_with_git, send_result_with_git_push, send_result_with_email, stats_script, supervision_sample_script, inference_sample_script))


if __name__ == '__main__':
    generate()