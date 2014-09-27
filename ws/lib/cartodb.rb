require 'open-uri'
require 'json'
require 'byebug'

class CartoDB

  CARTODB_DOMAIN = 'jacathon-huracan.cartodb.com'
  SQL_API_PREFIX = "http://#{CARTODB_DOMAIN}/api/v2/sql"
  TRACK_COLUMNS = [
                    "name", "_desc", "route_type", "route_classes", 
                    "horizontal_distance", "positive_difference" ,
                    "negative_difference", "aproximated_time",
                    "fid AS track_id"
                  ]

  def self.get_track(track_id)
    sql_fields = TRACK_COLUMNS.join(', ')
    sql = "SELECT #{sql_fields} FROM tracks where fid=#{track_id}"
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

    sql_filters = []
    if !options['term'].nil?
      sql_filters << " AND upper(t.name) LIKE '%#{options['term'].upcase}%' "
    end

    limit_sql = options['limit'].nil? ? " LIMIT 10" : " LIMIT #{options['limit']}"

    sql = "
      SELECT #{sql_fields.join(', ')} FROM track_points tp, tracks t
      WHERE track_seg_point_id = 0
        AND tp.track_fid = t.fid
      #{sql_filters.join("")}
      #{sql_order if geo}
      #{limit_sql if !limit_sql.nil?}
    "
    puts sql
    send_query(sql)
  end

  private

  def self.send_query(sql)
    JSON.parse(open(URI.encode("#{SQL_API_PREFIX}?q=#{sql}")).read)['rows']
  end


end
