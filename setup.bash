#!/bin/bash

# Load some Vars
. vars.bash


# unzip the ingested log files
# generate the json input
echo "extracting apache logs...."
gunzip -c ./ingest/logs.json.gz | ./scripts/bash/tojson.bash > ./ingest/logs_ingest.json

# install dependencies
cd ./scripts/coffee
npm install


cd ../.. 

echo "generating $NB_FILES bulk files.."
# generate bulk files
# Allowed parameters
# inputFolder : The path where the source JSON files are
# outputFolder : The path where the traget bulks are generated
# indexName : the name of the index
# typeName = the Type name
# bulkSize = Number of dpcs on each bulk (example: 500)
# nbFiles = Number of chunks to generate (set to -1 for let it generate as many as needed)
# indexType =  "daily" or "single" or "none" (default single) Use this option if you want to index to daily indices (ex daily logs) or one only index) When using daily , it will use the timestamp field in the source docs. "none" will skip the index line in the bulk (useful when not using the bulkAPI)
coffee ./scripts/coffee/genbulks.coffee ./ingest ./input apachelogs logs $DOCS_PER_BULK $NB_FILES daily
