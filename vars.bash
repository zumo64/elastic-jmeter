#!/bin/bash
JMETER_PATH=/Users/zumo/dev/java-tools/jmeter
USER=elastic
PASS=changeme
HOST=localhost
#JM_REMOTES=10.0.0.215,10.0.0.216
PORT=9200
INDEX=apachelogs-*
DOCS_PER_BULK=500
# parameter below tells how many files we want to generate if using the genBulks tool 
# set to -1 if unlimited
NB_FILES=10