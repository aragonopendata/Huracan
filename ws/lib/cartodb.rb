require 'open-uri'
require 'json'

class CartoDB

  CARTODB_DOMAIN='jacathon-huracan.cartodb.com'
  SQL_API_PREFIX="http://#{CARTODB_DOMAIN}/api/v1/sql"

  def self.get_tracks
    sql = "SELECT * FROM tracks LIMIT 2"
    send_query(sql)
  end

  private

  def self.send_query(sql)
    JSON.parse(open(URI.encode("#{SQL_API_PREFIX}?q=#{sql}")).read)['rows']
  end


end
