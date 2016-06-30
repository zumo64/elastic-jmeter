#!/bin/bash
JMETER_PATH=/Users/zumo/dev/java-tools/jmeter
USER=es_admin
PASS=password
HOST=192.168.99.100
PORT=9201
INDEX=apachelogs-*
QUERY_CSV=input1K1h.csv
SCROLL_CSV=inputScroll.csv
SHIELD_ENABLED=YES

# Througput in requests per minute
QUERY_THROUGHPUT=5.0
INDEX_THROUGHPUT=2.0
SCROLL_THROUGHPUT=20.0

# how many files in ./input ?
BULK_FILES=$(ls -l ./input/* | wc -l)

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

