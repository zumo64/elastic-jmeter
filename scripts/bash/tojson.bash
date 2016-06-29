#!/bin/bash
addBracket=$(sed '1s/^/[ /' )
echo "$addBracket" | awk '{print $0 ","}' | sed '$s/,$/]/'
