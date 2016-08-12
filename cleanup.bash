#!/bin/bash
# unzip the ingested log files



# Load some Vars
. vars.bash

rm ./ingest/logs_ingest.json
rm ./input/*
rm ./results/*.csv
rm ./logs/*.log

# delete all indices
curl -u "$USER:$PASS" -XDELETE "http://$HOST:$PORT/$INDEX"