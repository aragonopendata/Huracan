import ogr

# REQUIRE THAT track_points, waypoints and tracks are already created but empty

rd = ogr.Open('candanchu-la_raca.gpx')
#rd = ogr.Open('encinacorba_mirador.pgx')
wt = ogr.Open("PG:host=127.0.0.1 user=postgres dbname=jacathon", 1)

rlyr = rd.GetLayerByName('tracks')
wlyr = wt.GetLayerByName('tracks')

fid_map = {}

# Copy tracks, saving the database fid
for feat in rlyr:
    fFID = feat.GetFID()
    feat.SetFID(-1)
    rv = wlyr.CreateFeature(feat)
    fid_map[fFID] = feat.GetFID()

print "fid map:", fid_map

track_fid = fid_map[0]

ptrlyr = rd.GetLayerByName('track_points')
ptwlyr = wt.GetLayerByName('track_points')

# Copy track-points using the database track_fid rather than the file track_fid 
for feat in ptrlyr:
    feat.SetFID(-1)
    feat.SetField('track_fid', track_fid)
    #feat.SetField('track_fid', fid_map[feat.track_fid])
    rv = ptwlyr.CreateFeature(feat)



ptrlyr = rd.GetLayerByName('waypoints')
ptwlyr = wt.GetLayerByName('waypoints')
## DIRTY HACK: since waypoints doesn't have a native track_fid relation in gdal,
## track_fid is being set in the link2_text field. It should be normalized after
# Copy track-points using the database track_fid rather than the file track_fid 
for feat in ptrlyr:
    feat.SetFID(-1)
    feat.SetField('link2_text', track_fid)
    rv = ptwlyr.CreateFeature(feat)

