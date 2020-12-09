#!/bin/bash

# thanks: Swagger query builder, https://api.lens.org/swagger-ui.html#/scholarly/search

ACCESS_TOKEN='<TOKEN_GOES_HERE>'
START_YEAR=$1
END_YEAR=$2
SOURCE_TITLE=$3
OUT_DIR=$4
OUT_FILE_STEM=`echo "$SOURCE_TITLE" | sed 's/ /_/g'`

SOURCE_TITLE_HTML=`echo "$SOURCE_TITLE" | sed 's/ /+/g'`
COUNT=25
VIEW='COMPLETE'			# STANDARD [[ or COMPLETE :: can only be run on Institutional Elsevier--license authorised IP computer

printf "\n ... zzzZZ wait 5s ZZzzz ... \n"
sleep 5
printf "// Working on %s ...\n" "$SOURCE_TITLE"

# Run one query to get total num queries
START=0
INFO=`curl -s -X GET \
  --header 'Accept: application/json' \
  "https://api.elsevier.com/content/search/scopus?query=SRCTITLE(%7B${SOURCE_TITLE_HTML}%7D)&count=${COUNT}&date=$START_YEAR-$END_YEAR&apiKey=$ACCESS_TOKEN&ver=allexpand&view=${VIEW}&start=${START}"`
NUM_RES=`echo $INFO | jq -r '."search-results"."opensearch:totalResults"'`
RES_INDEX=`expr $START + $COUNT`
printf " --> found %s results ...\n" $NUM_RES

# .. push first results to outfile
OUT_FILE=`echo ${OUT_FILE_STEM}_${START}`
echo $INFO > ${OUT_DIR}/${OUT_FILE}

while [ ${RES_INDEX} -lt ${NUM_RES} ]
do

	sleep 1
	START=$RES_INDEX
	OUT_FILE=`echo ${OUT_FILE_STEM}_${START}`
	printf "    --> query from index %s ...\n" $START
	curl -s -X GET \
       --header 'Accept: application/json' \
       "https://api.elsevier.com/content/search/scopus?query=SRCTITLE(%7B${SOURCE_TITLE_HTML}%7D)&count=${COUNT}&date=$START_YEAR-$END_YEAR&apiKey=$ACCESS_TOKEN&ver=allexpand&view=${VIEW}&start=${START}" \
       > ${OUT_DIR}/${OUT_FILE}

    # .. update where we're up to
	RES_INDEX=`expr $START + $COUNT`

done
