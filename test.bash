#!/bin/bash
# This script requires input files in ./input
# each input file should be a proper BULK request :
# ex :
# { "index" : { "_index" : "apachelogs-2015.08.22", "_type" : "logs" } }
# {"message":"83.149.9.216 - - [22/Aug/2015:23:13:42 +0000] \"GET "patch":"1700"}}
# ...
#

# Load Global Vars
. vars.bash

# Througput in requests per minute
QUERY_THROUGHPUT=5.0
SCROLL_THROUGHPUT=20.0
# ingestion Througput in raw MB/s
INGEST_THROUGHPUT=0.5

# Tag this test
TEST_TAG=T0602

# how many files in ./input ?
BULK_FILES=$(ls -l ./input/* | wc -l)

ONE_FILE=$(ls ./input | head -1)

# Take  ONE_FILE  as sample for document size
SIZEDOCS=$(awk 'NR % 2 == 0' ./input/$ONE_FILE | wc -c)

TOAL_SIZE=$(echo "$SIZEDOCS/$DOCS_PER_BULK" | bc -l)
INDEX_THROUGHPUT=$(echo "$INGEST_THROUGHPUT*60*1048576/($DOCS_PER_BULK*$TOAL_SIZE)" | bc -l)

# Create apachelogs-* template
curl -u "$USER:$PASS" -XPUT "http://$HOST:$PORT/_template/template1" -d @./templates/apache_logs.json

# launch test
"$JMETER_PATH/bin/jmeter" -n -t ./tests/elk_stress.jmx \
  -JtestScroll=false  \
  -JtestIngest=true  \
  -JtestQuery=true \
  -Jhost="$HOST"  \
  -Jport="$PORT" \
  -Juser="$USER" \
  -Jpass="$PASS" \
  -JinputFiles="$BULK_FILES" \
  -JindexName="$INDEX" \
  -JtypeName=logs \
  -JqueryThroughPut="$QUERY_THROUGHPUT" \
  -JindexThroughPut="$INDEX_THROUGHPUT" \
  -JscrollThroughPut="$SCROLL_THROUGHPUT" \
  -JqueryCSVFile="$QUERY_CSV" \
  -JscrollCSVFile="$SCROLL_CSV" \
  -JtestRunId="$TEST_TAG" -l ./results/results.csv

