#!/usr/bin/env python
import os
import sys
import time
import json
import logging
from collections import defaultdict
from random import randint, choice
from datetime import datetime



from elasticsearch import Elasticsearch, helpers


# returns avg size raw json
def scan(indexName,path):
    with open(path, 'r') as m:
        QRY = json.load(m)
    for docs in helpers.scan(es, query=QRY, scroll=u'1m', raise_on_error=True,index=indexName,preserve_order=False, size=100):pass

host  = sys.argv[1]
port      = sys.argv[2]
indexName = sys.argv[3]
qryPath   = sys.argv[4]

connectionHost = "http://"+host+":"+port
print connectionHost
# cluster to run against
es = Elasticsearch(connectionHost,http_auth=('es_admin', 'password'),timeout=30)
startTime = datetime.now()
scan(indexName,qryPath)
timeSpent = datetime.now() - startTime
print indexName+ ","+ str(timeSpent)

    
    
