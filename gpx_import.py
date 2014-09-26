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

admin_conn = psycopg2.connect("dbname=postgres user=postgres")
admin_conn.set_isolation_level(0)
admin_cur = admin_conn.cursor()

admin_cur.execute("DROP DATABASE IF EXISTS %s" % DBNAME)
admin_cur.execute("CREATE DATABASE %s" % DBNAME)

conn = psycopg2.connect("dbname=%s user=%s" % (DBNAME, DBUSER))
conn.set_isolation_level(0)
cur = conn.cursor()

cur.execute(open("%s/tracks.sql" % SCHEMA_DUMPS_PATH, "r").read())
cur.execute(open("%s/track_points.sql" % SCHEMA_DUMPS_PATH, "r").read())
cur.execute(open("%s/waypoints.sql" % SCHEMA_DUMPS_PATH, "r").read())

cur.execute("ALTER TABLE waypoints ADD COLUMN track_fid integer")

#gdal.SetConfigOption('GPX_USE_EXTENSIONS', 'YES')
# REQUIRE THAT track_points, waypoints and tracks are already created but empty
# GPX_USE_EXTENSIONS=yes
#fooField = ogr.FieldDefn("foobar", ogr.OFTInteger)
#rlyr.CreateField(fooField, "GPX_USE_EXTENSIONS=yes")

GPX_FILES_PATH="/home/luisico/devel/jacathon/routes"

gpx_files = glob.glob("%s/*.gpx" % GPX_FILES_PATH)

for gpx in gpx_files:
    filename = os.path.basename(gpx)
    route_id = int(filename.split(".")[0])
    print route_id
    
    route_json = json.load(open("%s/%s.json" % (GPX_FILES_PATH, route_id)))


    rd = ogr.Open(gpx)
    wt = ogr.Open("PG:host=127.0.0.1 user=postgres dbname=jacathon", 1)
    
    ## LOAD tracks LAYER
    rlyr = rd.GetLayerByName('tracks')
    wlyr = wt.GetLayerByName('tracks')

    #fid_map = {}

    # Copy tracks, saving the database fid
    for feat in rlyr:
        #pdb.set_trace()
        fFID = feat.GetFID()
        #feat.SetFID(-1)
        feat.SetFID(route_id)
        rv = wlyr.CreateFeature(feat)
        #fid_map[fFID] = feat.GetFID()
        track_fid = feat.GetFID()
    
    
    #print "fid map:", fid_map

    #track_fid = fid_map[0]

    ## LOAD track_points LAYER
    ptrlyr = rd.GetLayerByName('track_points')
    ptwlyr = wt.GetLayerByName('track_points')

    # Copy track-points using the database track_fid rather than the file track_fid 
    for feat in ptrlyr:
        feat.SetFID(-1)
        feat.SetField('track_fid', track_fid)
        #feat.SetField('track_fid', fid_map[feat.track_fid])
        rv = ptwlyr.CreateFeature(feat)


    ## LOAD waypoints LAYER
    ptrlyr = rd.GetLayerByName('waypoints')
    ptwlyr = wt.GetLayerByName('waypoints')
    ## DIRTY HACK: since waypoints doesn't have a native track_fid relation in gdal,
    ## track_fid is being set in the link2_text field. It should be normalized after
    # Copy track-points using the database track_fid rather than the file track_fid 
    for feat in ptrlyr:
        feat.SetFID(-1)
        #feat.SetField('link2_text', track_fid)
        rv = ptwlyr.CreateFeature(feat)
        waypoint_fid = feat.GetFID()
        cur.execute("UPDATE waypoints SET track_fid=%s WHERE ogc_fid=%s" % (track_fid, waypoint_fid))

cur.execute("ALTER TABLE tracks ADD COLUMN route_type text")
cur.execute("ALTER TABLE tracks ADD COLUMN route_classes text[]")
cur.execute("ALTER TABLE tracks ADD COLUMN horizontal_distance float")
cur.execute("ALTER TABLE tracks ADD COLUMN positive_difference float")
cur.execute("ALTER TABLE tracks ADD COLUMN negative_difference float")
cur.execute("ALTER TABLE tracks ADD COLUMN aproximated_time float")

#for gpx in gpx_files:
#    filename = os.path.basename(gpx)
#    route_id = int(filename.split(".")[0])
#    print route_id
#    
#    route_json = json.load(open("%s/%s.json" % (GPX_FILES_PATH, route_id)))
#
#    cur.execute("UPDATE tracks SET route_type=%s,route_classes=%s,horizontal_distance=%s,positive_difference=%s,negative_difference=%s,aproximated_time=%s WHERE ogc_fid=%s" % (route_json['route_type'], "'{%s}'" % (',').join(route_json['route_classes'])), route_json['horizontal_distance'], route_json['positive_difference'], route_json['negative_difference'], route_json['aproximated_time'], route_id)
