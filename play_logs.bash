#!/bin/bash
#
# This script  will replay raw log files located in the input folder. 
# Use setup_play_logs.bash to generate 1 file. 
 

# Load Global Vars
. vars.bash

# NB simulated  processes generating logs simultaneoulsy
NB_THREADS=4

# NB events per minute each process is generating
EVENTS_PER_MINUTE=500


# how many files in ./input ?
LOG_FILES=$(ls -l ./input/* | wc -l)

# launch test
"$JMETER_PATH/bin/jmeter" -n -t ./tests/play_logs.jmx \
    -JinputFiles="$LOG_FILES" \
    -JthreadNum="$NB_THREADS" \
    -JeventsPerMin="$EVENTS_PER_MINUTE"

