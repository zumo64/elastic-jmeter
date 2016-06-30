#!/bin/bash

# unzip the ingested log files
# generate the json input
gunzip -c ./ingest/logs.json.gz | ./scripts/bash/tojson.bash > ./ingest/logs_ingest.json

# install dependencies
cd ./scripts/coffee
npm install

# generate bulk files
cd ../..
coffee ./scripts/coffee/genbulks.coffee ./ingest ./input apachelogs logs 500 20 daily
