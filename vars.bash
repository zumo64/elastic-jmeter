#!/bin/bash
JMETER_PATH=/usr/local/jmeter/apache-jmeter-3.0
USER=es_admin
PASS=password
HOST=localhost
PORT=9200
INDEX=apachelogs-*
DOCS_PER_BULK=1000
# parameter below tells how many files we want to generate if using the genBulks tool 
# set to -1 if unlimited
NB_FILES=-1