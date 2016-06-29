#!/bin/bash
# unzip the ingested log files

USER=es_admin
PASS=password
HOST=192.168.99.100
PORT=9201
INDEX=apachelogs-*

rm ./ingest/logs_ingest.json
rm ./input/*
rm ./results/*.csv

# delete all indices
curl -u "$USER:$PASS" -XDELETE "http://$HOST:$PORT/$INDEX"