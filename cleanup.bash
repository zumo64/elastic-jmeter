#!/bin/bash
# unzip the ingested log files



# Load some Vars
. vars.bash

if [ -f ./ingest/logs_ingest.json ];
then 
  rm ./ingest/logs_ingest.json
fi

if [ -d ./input ];
then
  rm ./input/*
fi

if [ -d ./results ];
then
  rm ./results/*.csv
fi

if [ -d ./logs ];
then
  rm ./logs/*.log
fi

# delete all indices
#curl -u "$USER:$PASS" -XDELETE "http://$HOST:$PORT/$INDEX"