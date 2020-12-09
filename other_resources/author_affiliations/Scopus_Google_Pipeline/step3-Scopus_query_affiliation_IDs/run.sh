#!/bin/bash

#IN_FILE='scopus_affiliations.csv'
IN_FILE=$1
OUTDIR='outputs_json'

mkdir $OUTDIR

# -- cut out just second col
tail -n +2 $IN_FILE |  awk -F'\t' '{print $1}' > tmp
# .. split by tabs, print only col 2

# -- shoot each journal at the API, one by one
cat tmp | tr \\n \\0 | xargs -n 1 -0 -I AN_AFID ./scopus_query.sh AN_AFID $OUTDIR
# .. tr: switches line endings to '\0'; which allows for the -0 flag with xargs, splitting by '\0'
# .. xargs:
#      -n 1 :: take one arg at a time
#      -0   :: use \0 as arg split (so a line)
#      -I A_JOURNAL_TITLE :: use A_JOURNAL_TITLE as the proxy for each arg in our utility code
