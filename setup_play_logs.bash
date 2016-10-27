#!/bin/bash
# {{ lookup('file', './filebeat.yml')|from_yaml }}
# unzip the ingested log files
# generate the json input
echo "extracting apache logs...."
gunzip -c ./ingest/logs.raw.gz > ./input/logs.raw 
