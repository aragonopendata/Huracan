require 'open-uri'
require 'json'

class CartoDB

  CARTODB_DOMAIN='jacathon-huracan.cartodb.com'
  SQL_API_PREFIX="http://#{CARTODB_DOMAIN}/api/v2/sql"

  def self.get_track(track_id)
    sql = "SELECT * FROM tracks where fid=#{track_id}"
    send_query(sql)[0]
  end

  def self.get_tracks(options = {})
    options['term'] ||= ''

    geo = false
    if !options['lat'].nil? && !options['lon'].nil?
      distance_column = ", ST_Distance(tp.the_geom::geography, ST_SetSRID(ST_Point(#{options['lat']}, #{options['lon']}),4326)::geography) AS distance"
      sql_order = " ORDER BY distance ASC"
      geo = true
    end

    sql_filters = []
    if !options['term'].nil?
      sql_filters << " AND upper(t.name) LIKE '%#{options['term'].upcase}%' "
    end

    limit_sql = options['limit'].nil? ? " LIMIT 10" : " LIMIT #{options['limit']}"

    sql = "
      SELECT t.fid AS track_id, tp.cartodb_id, tp.ele, tp.the_geom, tp.the_geom_webmercator, t.name FROM track_points tp, tracks t #{distance_column if geo}
      WHERE track_seg_point_id = 0
        AND tp.track_fid = t.fid
      #{sql_filters.join("")}
      #{sql_order if geo}
      #{limit_sql if !limit_sql.nil?}
    "
    send_query(sql)
  end

  #def self.get_tracks_by_distance(lat, lon, top = 10)
  #  sql = "
  #    SELECT tp.cartodb_id, tp.ele, tp.the_geom, tp.the_geom_webmercator, t.name FROM track_points tp, tracks t 
  #    WHERE track_seg_point_id = 0 
  #      AND tp.track_fid = t.fid 
  #      AND upper(t.name) LIKE '%BELLO%' 
  #    ORDER BY ST_Distance(tp.the_geom::geography, ST_SetSRID(ST_Point(#{lat}, #{lon}),4326)::geography) 
  #      ASC 
  #    LIMIT #{top}
  #  "
  #  send_query(sql)
  #end

  private

  def self.send_query(sql)
    JSON.parse(open(URI.encode("#{SQL_API_PREFIX}?q=#{sql}")).read)['rows']
  end


end
