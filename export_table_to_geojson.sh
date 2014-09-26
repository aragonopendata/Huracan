#!/bin/bash

[[ -z ${1} ]] && echo "You need to pass a table name" && exit 1

TABLE_NAME=$1
DBNAME='jacathon'

ogr2ogr -f geojson ${TABLE_NAME}.geojson PG:"host=127.0.0.1 dbname=${DBNAME} user=postgres" "${TABLE_NAME}"
