#!/bin/bash

# thanks: Swagger query builder, https://api.lens.org/swagger-ui.html#/scholarly/search

ACCESS_TOKEN='<TOKEN_GOES_HERE>'
AFID=$1
OUT_DIR=$2
OUT_FILE=${OUT_DIR}/id_${AFID}

VIEW='STANDARD'			# STANDARD [[ or COMPLETE :: can only be run on Institutional Elsevier--license authorised IP computer

printf "// Working on %s ...\n" "$AFID"

curl -s -X GET \
      --header 'Accept: application/json' \
      "https://api.elsevier.com/content/affiliation/affiliation_id/${AFID}?apiKey=${ACCESS_TOKEN}&ver=allexpand&view=${VIEW}" \
      > ${OUT_FILE}

printf "\n ... zzzZZ wait 2s ZZzzz ... \n"
sleep 2
