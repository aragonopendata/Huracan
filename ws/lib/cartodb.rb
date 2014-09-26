require 'open-uri'
require 'json'

class CartoDB

  CARTODB_DOMAIN='jacathon-huracan.cartodb.com'
  SQL_API_PREFIX="http://#{CARTODB_DOMAIN}/api/v1/sql"

  def self.get_tracks(options = {})
    if options.empty?
      raise "Wake up McFly!"
    end
    sql_filters = []
    if !options['term'].nil?
      sql_filters << " AND upper(t.name) LIKE '%#{options['term'].upcase}%' "
    end
    if !options['lat'].nil? && !options['lon'].nil?
      sql_filters << " ORDER BY ST_Distance(tp.the_geom::geography, ST_SetSRID(ST_Point(#{options['lat']}, #{options['lon']}),4326)::geography) ASC "
    end
    sql_filters << options['limit'].nil? ? " LIMIT 10" : " LIMIT #{options['limit']}"

    sql = "
      SELECT tp.cartodb_id, tp.ele, tp.the_geom, tp.the_geom_webmercator, t.name FROM track_points tp, tracks t 
      WHERE track_seg_point_id = 0 
        AND tp.track_fid = t.ogc_fid 
      #{sql_filters.join("")}
    "
    send_query(sql)
  end

  #def self.get_tracks_by_distance(lat, lon, top = 10)
  #  sql = "
  #    SELECT tp.cartodb_id, tp.ele, tp.the_geom, tp.the_geom_webmercator, t.name FROM track_points tp, tracks t 
  #    WHERE track_seg_point_id = 0 
  #      AND tp.track_fid = t.ogc_fid 
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
