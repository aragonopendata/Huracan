require 'open-uri'
require 'json'
#require 'byebug'

class CartoDB

  CARTODB_USERNAME = 'jacathon-huracan'
  CARTODB_DOMAIN = "#{CARTODB_USERNAME}.cartodb.com"
  SQL_API_PREFIX = "http://#{CARTODB_DOMAIN}/api/v2/sql"
  TRACK_COLUMNS = [
                    "name", "_desc", "route_type", "route_classes", 
                    "horizontal_distance", "positive_difference" ,
                    "negative_difference", "aproximated_time",
                    "fid AS track_id"
                  ]


  def self.get_track(track_id)
    sql_fields = TRACK_COLUMNS.map {|c| "t.#{c}"}
    sql = "SELECT ST_X(tp.the_geom) as lon, ST_Y(tp.the_geom) as lat, #{sql_fields.join(', ')} FROM tracks t, track_points tp WHERE t.fid = tp.track_fid AND tp.track_seg_point_id = 0 AND fid=#{track_id}"
    puts sql
    send_query(sql)[0]
  end

  def self.get_tracks(options = {})
    sql_fields = TRACK_COLUMNS.map {|c| "t.#{c}"}

    options['term'] ||= ''

    geo = false
    if !options['lat'].nil? && !options['lon'].nil?
      distance_column = "ST_Distance(tp.the_geom::geography, ST_SetSRID(ST_Point(#{options['lon']}, #{options['lat']}),4326)::geography) AS distance"
      sql_order = " ORDER BY distance ASC"
      sql_fields << distance_column
      geo = true
    end

    sql_fields << "ST_X(tp.the_geom) as lon"
    sql_fields << "ST_Y(tp.the_geom) as lat"

    sql_filters = []
    if !options['term'].nil?
      sql_filters << " AND upper(t.name) LIKE '%#{options['term'].upcase}%' "
    end

    limit_sql = options['limit'].nil? ? " LIMIT 5" : " LIMIT #{options['limit']}"

    sql = "
      SELECT #{sql_fields.join(', ')} FROM track_points tp, tracks t
      WHERE tp.track_seg_point_id = 0
        AND tp.track_fid = t.fid
      #{sql_filters.join("")}
      #{sql_order if geo}
      #{limit_sql if !limit_sql.nil?}
    "
    send_query(sql)
  end

  def self.get_nearest_municipality(lon, lat)
    distance_column = "ST_Distance(m.the_geom::geography, ST_SetSRID(ST_Point(#{lon}, #{lat}),4326)::geography) AS distance"
    sql = "
      SELECT m.name, #{distance_column} FROM municipios_geocoded m
      ORDER BY distance asc
      LIMIT 1
    "
    send_query(sql)[0]['name']
  end

  private

  def self.send_query(sql)
    JSON.parse(open(URI.encode("#{SQL_API_PREFIX}?q=#{sql}")).read)['rows']
  end


end
