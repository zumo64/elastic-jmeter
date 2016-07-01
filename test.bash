#!/bin/bash
# Load some Vars
. vars.bash

# Througput in requests per minute
QUERY_THROUGHPUT=5.0
SCROLL_THROUGHPUT=20.0
# ingestion Througput in raw MB/s
INGEST_THROUGHPUT=1

# how many files in ./input ?
BULK_FILES=$(ls -l ./input/* | wc -l)

# Take  file_0 as sample for document size
SIZEDOCS=$(awk 'NR % 2 == 0' ./input/file_0.txt | wc -c)
AVGSIZE=$(echo "$SIZEDOCS/$DOCS_PER_BULK" | bc -l)
INDEX_THROUGHPUT=$(echo "$INGEST_THROUGHPUT*60*1048576/($DOCS_PER_BULK*$AVGSIZE)" | bc -l)

# Create template
curl -u "$USER:$PASS" -XPUT "http://$HOST:$PORT/_template/template1" -d @./templates/apache_logs.json

# launch test
"$JMETER_PATH/bin/jmeter" -n -t ./tests/elk_stress.jmx \
  -JtestScroll=false  \
  -JtestIngest=true  \
  -JtestQuery=true \
  -Jhost="$HOST"  \
  -Jport="$PORT" \
  -JinputFiles="$BULK_FILES" \
  -JindexName="$INDEX" \
  -JtypeName=logs \
  -JqueryThroughPut="$QUERY_THROUGHPUT" \
  -JindexThroughPut="$INDEX_THROUGHPUT" \
  -JscrollThroughPut="$SCROLL_THROUGHPUT" \
  -JqueryCSVFile="$QUERY_CSV" \
  -JscrollCSVFile="$SCROLL_CSV" \
  -JtestRunId=T0602 -l ./results/results.csv

