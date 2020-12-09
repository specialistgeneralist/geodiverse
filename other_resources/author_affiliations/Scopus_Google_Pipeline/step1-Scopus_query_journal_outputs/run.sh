#!/bin/bash

# example: $ ./run 'journals_list_test.csv'

IN_FILE=$1
START_YEAR=2019
END_YEAR=2020
OUTDIR='outputs_json'

mkdir $OUTDIR

# -- cut out just second col
cat $IN_FILE |  awk -F'\t' '{print $2}' > tmp
# .. split by tabs, print only col 2

# -- shoot each journal at the API, one by one
cat tmp | tr \\n \\0 | xargs -n 1 -0 -I A_JOURNAL_TITLE ./scopus_query.sh $START_YEAR $END_YEAR A_JOURNAL_TITLE $OUTDIR
# .. tr: switches line endings to '\0'; which allows for the -0 flag with xargs, splitting by '\0'
# .. xargs:
#      -n 1 :: take one arg at a time
#      -0   :: use \0 as arg split (so a line)
#      -I A_JOURNAL_TITLE :: use A_JOURNAL_TITLE as the proxy for each arg in our utility code

