#!/bin/bash
# Load Global Vars
. vars.bash

curl -u "$USER:$PASS" -XPOST "http://$HOST:$PORT/_bulk" --data-binary "@$1"


