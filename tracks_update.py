import ogr
from osgeo import ogr, osr, gdal
import psycopg2
import json
import glob
import os
import pdb

DBNAME='jacathon'
DBUSER='postgres'
SCHEMA_DUMPS_PATH='./gpx_sql_schemas'

conn = psycopg2.connect("dbname=%s user=%s" % (DBNAME, DBUSER))
conn.set_isolation_level(0)
cur = conn.cursor()

GPX_FILES_PATH="/home/luisico/devel/jacathon/routes"

gpx_files = glob.glob("%s/*.gpx" % GPX_FILES_PATH)

for gpx in gpx_files:
    filename = os.path.basename(gpx)
    route_id = int(filename.split(".")[0])
    print route_id
    
    route_json = json.load(open("%s/%s.json" % (GPX_FILES_PATH, route_id)))[0]
   
    route_classes = "{%s}" % (',').join(set(route_json['route_classes']))

    cur.execute("UPDATE tracks SET route_type='%s',route_classes='%s',horizontal_distance=%s,positive_difference=%s,negative_difference=%s,aproximated_time=%s WHERE ogc_fid=%s" % (route_json['route_type'], route_classes, route_json['horizontal_distance'], route_json['positive_difference'], route_json['negative_difference'], route_json['aproximated_time'], route_id))
