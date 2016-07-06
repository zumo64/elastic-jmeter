#!/bin/bash
# Load Global Vars
. vars.bash

# Create apachelogs-* template
curl -u "$USER:$PASS" -XPUT "http://$HOST:$PORT/_template/template1" -d @./templates/apache_logs.json



