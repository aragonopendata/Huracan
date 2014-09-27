#!/bin/bash

ogr2ogr -progress -f geojson tracks.geojson PG:"host=127.0.0.1 dbname=jacathon user=postgres" "tracks"
ogr2ogr -progress -f geojson track_points.geojson PG:"host=127.0.0.1 dbname=jacathon user=postgres" "track_points"
ogr2ogr -progress -f geojson waypoints.geojson PG:"host=127.0.0.1 dbname=jacathon user=postgres" "waypoints"
